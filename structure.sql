-- MySQL dump 10.13  Distrib 5.5.50, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: dpc
-- ------------------------------------------------------
-- Server version	5.5.50-0+deb8u1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `disname`
--

DROP TABLE IF EXISTS `disname`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `disname` (
  `did` char(6) NOT NULL DEFAULT '',
  `dname` text,
  PRIMARY KEY (`did`),
  KEY `disname_did` (`did`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `hospitals`
--

DROP TABLE IF EXISTS `hospitals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hospitals` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `year` int(11) NOT NULL DEFAULT '0',
  `nr` char(5) DEFAULT NULL,
  `oldnr` char(5) DEFAULT NULL,
  `name` text,
  PRIMARY KEY (`id`,`year`),
  UNIQUE KEY `s_yn` (`year`,`nr`),
  KEY `nr` (`nr`),
  KEY `oldnr` (`oldnr`),
  KEY `year` (`year`),
  KEY `shisetsu_id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17787 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `summary`
--

DROP TABLE IF EXISTS `summary`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `summary` (
  `year` int(11) NOT NULL DEFAULT '0',
  `nr` char(5) NOT NULL DEFAULT '',
  `did` char(6) NOT NULL DEFAULT '',
  `opid` char(2) NOT NULL DEFAULT '',
  `cases` int(11) DEFAULT NULL,
  `days` int(11) DEFAULT NULL,
  PRIMARY KEY (`year`,`nr`,`did`,`opid`),
  KEY `yn` (`year`,`nr`),
  KEY `dis_did` (`did`),
  KEY `dis_opid` (`opid`),
  KEY `snr` (`nr`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `temp`
--

DROP TABLE IF EXISTS `temp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `temp` (
  `nr` char(5) DEFAULT NULL,
  `oldnr` char(5) DEFAULT NULL,
  `name` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tr1`
--

DROP TABLE IF EXISTS `tr1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tr1` (
  `year` int(11) NOT NULL DEFAULT '0',
  `nr` char(5) NOT NULL DEFAULT '',
  `did` char(6) NOT NULL DEFAULT '',
  `withop` tinyint(1) NOT NULL DEFAULT '0',
  `withtr1` tinyint(1) NOT NULL DEFAULT '0',
  `cases` int(11) DEFAULT NULL,
  `days` int(11) DEFAULT NULL,
  PRIMARY KEY (`year`,`nr`,`did`,`withop`,`withtr1`),
  KEY `yn` (`year`,`nr`),
  KEY `did` (`did`),
  KEY `t1did` (`did`),
  KEY `tr1nr` (`nr`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tr2`
--

DROP TABLE IF EXISTS `tr2`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tr2` (
  `year` int(11) NOT NULL DEFAULT '0',
  `nr` char(5) NOT NULL DEFAULT '',
  `did` char(6) NOT NULL DEFAULT '',
  `withop` tinyint(1) NOT NULL DEFAULT '0',
  `withtr2` tinyint(1) NOT NULL DEFAULT '0',
  `cases` int(11) DEFAULT NULL,
  `days` int(11) DEFAULT NULL,
  PRIMARY KEY (`year`,`nr`,`did`,`withop`,`withtr2`),
  KEY `yn` (`year`,`nr`),
  KEY `did` (`did`),
  KEY `t2did` (`did`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `vh`
--

DROP TABLE IF EXISTS `vh`;
/*!50001 DROP VIEW IF EXISTS `vh`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `vh` (
  `id` tinyint NOT NULL,
  `name` tinyint NOT NULL,
  `did` tinyint NOT NULL,
  `dname` tinyint NOT NULL,
  `year` tinyint NOT NULL,
  `sum(cases)` tinyint NOT NULL,
  `sum(days)` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `vh`
--

/*!50001 DROP TABLE IF EXISTS `vh`*/;
/*!50001 DROP VIEW IF EXISTS `vh`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`dpc`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `vh` AS select `hospitals`.`id` AS `id`,`hospitals`.`name` AS `name`,`summary`.`did` AS `did`,`disname`.`dname` AS `dname`,`summary`.`year` AS `year`,sum(`summary`.`cases`) AS `sum(cases)`,sum(`summary`.`days`) AS `sum(days)` from ((`summary` left join `hospitals` on(((`summary`.`year` = `hospitals`.`year`) and (`summary`.`nr` = `hospitals`.`nr`)))) left join `disname` on((`summary`.`did` = `disname`.`did`))) group by `summary`.`did`,`summary`.`year` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-11-07 13:07:11
