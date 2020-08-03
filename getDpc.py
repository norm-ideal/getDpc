#!/usr/bin/python
# -*- coding: utf-8 -*-

import dbconfig

import sys
import requests
import re
import html
from bs4 import BeautifulSoup
import dpcExtractor
import mysql.connector

if len(sys.argv) != 3:
    print()
    print( "Usage: getDpc year path" )
    print()
    print( "year : data year in western year (like 2013)" )
    print( "path : the webpage URL" )
    print()
    sys.exit(-1)

year = int(sys.argv[1])
fullurl = sys.argv[2]
sitematcher = re.compile("(.*\.go\.jp/)(.*)");
surl = sitematcher.match(fullurl)
if surl:
    siteurl = surl.group(1)
    part = sys.argv[2].rpartition('/')
    baseurl = part[0] + "/"
    print(siteurl)
    print(baseurl)
else:
    sys.exit(-1)


def download_file(url):
    url = siteurl + url
    local_filename = 'downloads/'+url.split('/')[-1]
    # NOTE the stream=True parameter

    print(url)

    r = requests.get(url, stream=True)
    with open(local_filename, 'wb') as f:
        for chunk in r.iter_content(chunk_size=1024):
            if chunk: # filter out keep-alive new chunks
                f.write(chunk)
                #f.flush() commented by recommendation from J.F.Sebastian
    return local_filename


matcher = re.compile(u'(MDC[0-9\-]{2,4})')
shochi = re.compile(u'処置([12])')
gaiyou = re.compile(u'施設概要表')

print("Connecting to MHLW")
r2 = requests.get(fullurl)
soup = BeautifulSoup(r2.text, "html.parser")

mydb = dbconfig.mydb
con = mysql.connector.connect(host=mydb['host'],user=mydb['user'],db=mydb['database'],charset='utf8')

print("Starting Analysis")
links = soup.find_all("a")
filetype = 0
for link in links:
    href = link.attrs['href']
    text = link.text

    # Shisetsu Gaiyou Hyou
    if gaiyou.search(text):
        print("Hospital Name List")
        fn = download_file(href)
        dpcExtractor.getHospitals(fn, year, con)
    else:
        match = matcher.search(text)
        if match:
            s = shochi.search(text)
            if s:
                filetype = int(s.group(1))
            else:
                filetype = 0
            print("Filetype ", filetype)
            print(match.group(1))
            print(href)
            fn = download_file(href)
            if filetype == 0:
                dpcExtractor.getOneSheetS(fn, year, con)
            elif filetype == 1:
                dpcExtractor.getOneSheetT(fn, year, con, 1)
            elif filetype == 2:
                dpcExtractor.getOneSheetT(fn, year, con, 2)
            print("---------------")
