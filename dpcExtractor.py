import config

import sys
import mysql.connector

# old version of excel
import xlrd

# new version of xlsx
# from openpyxl import load_workbook
# wb = load_workbook('')


# get one SUMMARY sheet with year and database-connection
# commits database, but does not close
# Caution! if dupliated year-nr key appears, it is treated as "seperated cases" and added into existing value.

def convertNaN( value ):
    if value == '-':
        result = 0
    else:
        result = float(value)
    return result

# Get the sheet type I - with operation ID { 99 | 97 | ... }
def getOneSheetS(sheetname, year, dbcon):
    # open the file and prepare for the sheet
    wb = xlrd.open_workbook(sheetname)
    sheet = wb.sheets()[0]

    # prepare the SQL commands
    insertdname = "insert into disname (did, dname) values ('%s', '%s') on duplicate key update dname='%s'"
    insertcases = "insert into summary (year, nr, did, opid, cases, days) values (%d, '%s', '%s', '%s', %d, %d) on duplicate key update cases=cases+%d, days=days+%d"

    # process the sheet. The data line is starting from row 5 (index 4)
    for r in range(4, sheet.nrows):
        # the number for the hospital for the year
        nr = sheet.cell(r,0).value

        # show progress
        sys.stdout.write( "{0:2.0f}% {1}\r".format( (r-4.0)/(sheet.nrows-4)*100, nr) )

        # The data in the line starts from column 4 (index 3)
        c = 3 

        did = "000000"
        dname = "------"

        occflag = True  # flag to distiguish between cases and days
        days = 0        # days ( round(occurance * average_days ) 
        occs = {};      # occurance array of cases, indexed by operation_ID

        while c < sheet.ncols:
            if sheet.cell(0,c).value:
                did = sheet.cell(0,c).value
                dname = sheet.cell(1,c).value
                occflag = True
                # SQL insert into summary
                # print did, dname
                if r == 4:
                    sql = insertdname % (did, dname, dname)
                    dbcon.cursor().execute(sql)
            elif sheet.cell(2,c).value:
                occflag = False
            
            ocid = sheet.cell(3,c).value
            v  = convertNaN(sheet.cell(r,c).value)

            if len(ocid) == 2:  # ignore 97-subtotal
                v = float(v)
                if occflag:
                    occs[ocid] = v;
                else:
                    days = round(occs[ocid] * v)
                    sql = insertcases % (int(year), nr, did, ocid, occs[ocid], days, occs[ocid], days);
                    dbcon.cursor().execute(sql);
            
            c = c + 1
    dbcon.commit()
    print "processed ", sheetname

# Get the sheet type II - with operation/treatment
def getOneSheetT(sheetname, year, dbcon, treatment):
    wb = xlrd.open_workbook(sheetname)
    sheet = wb.sheets()[0]

    insertdname = "insert into disname (did, dname) values ('%s', '%s') on duplicate key update dname='%s'"
    if treatment == 1:
        insertcases = "insert into tr1 (year, nr, did, withop, withtr1, cases, days)"
    else:
        insertcases = "insert into tr2 (year, nr, did, withop, withtr2, cases, days)"

    insertcases += " values (%d, '%s', '%s', %d, %d, %d, %d) on duplicate key update cases=cases+%d, days=days+%d"

    for r in range(5, sheet.nrows):
        nr = sheet.cell(r,0).value
        sys.stdout.write( "{0:2.0f}% {1}\r".format( (r-4.0)/(sheet.nrows-4)*100, nr) )
        c = 3 

        nr = sheet.cell(r, 0).value

        while c < sheet.ncols:
            did = sheet.cell(0,c).value
            dname = sheet.cell(1,c).value
            
            # for the first line, add disname (update if exists)
            if r==5:
                sql = insertdname % (did, dname, dname)
                dbcon.cursor().execute(sql)

            c_op1tr1 = convertNaN(sheet.cell(r,c  ).value)
            c_op1tr0 = convertNaN(sheet.cell(r,c+1).value)
            c_op0tr1 = convertNaN(sheet.cell(r,c+2).value)
            c_op0tr0 = convertNaN(sheet.cell(r,c+3).value)

            d_op1tr1 = round( convertNaN(sheet.cell(r,c+4).value) * c_op1tr1 )
            d_op1tr0 = round( convertNaN(sheet.cell(r,c+5).value) * c_op1tr0 )
            d_op0tr1 = round( convertNaN(sheet.cell(r,c+6).value) * c_op0tr1 )
            d_op0tr0 = round( convertNaN(sheet.cell(r,c+7).value) * c_op0tr0 )

            sql = insertcases % (year, nr, did, True , True , c_op1tr1, d_op1tr1, c_op1tr1, d_op1tr1, )
            dbcon.cursor().execute(sql)
            sql = insertcases % (year, nr, did, True , False, c_op1tr0, d_op1tr0, c_op1tr0, d_op1tr0, )
            dbcon.cursor().execute(sql)
            sql = insertcases % (year, nr, did, False, True , c_op0tr1, d_op0tr1, c_op0tr1, d_op0tr1, )
            dbcon.cursor().execute(sql)
            sql = insertcases % (year, nr, did, False, False, c_op0tr0, d_op0tr0, c_op0tr0, d_op0tr0, )
            dbcon.cursor().execute(sql)
            
            c = c + 8

    dbcon.commit()
    print "processed ", sheetname


# Get the sheet type Hospital List
def getHospitals(sheetname, year, dbcon):
    wb = xlrd.open_workbook(sheetname)
    sheet = wb.sheets()[0]

    sql = "insert into hospitals (year, nr, oldnr, name) values (%d, '%s', '%s', '%s')"
    sql += " on duplicate key update name = '%s'"
    for r in range(1, sheet.nrows):
        nr = sheet.cell(r,0).value
        if not nr:
            break 
        oldnr = sheet.cell(r,1).value
        name = sheet.cell(r,2).value
        sys.stdout.write( "{0:2.0f}% {1}\r".format( (r-1.0)/(sheet.nrows-1)*100, nr) )
        dbcon.cursor().execute( sql % (year, nr, oldnr, name, name) )

    dbcon.cursor().execute( "update hospitals as new right join hospitals as old on new.oldnr = old.nr and new.year = old.year+1 and new.year = %d set new.id = old.id" % (year,) )


