-- MySQL dump 10.13  Distrib 8.0.38, for Win64 (x86_64)
--
-- Host: localhost    Database: blinkmetrics_project_warehouse
-- ------------------------------------------------------
-- Server version	8.0.38

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `dim_cities`
--

DROP TABLE IF EXISTS `dim_cities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dim_cities` (
  `city_id` bigint NOT NULL,
  `city` text,
  `country` text,
  PRIMARY KEY (`city_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dim_cities`
--

LOCK TABLES `dim_cities` WRITE;
/*!40000 ALTER TABLE `dim_cities` DISABLE KEYS */;
INSERT INTO `dim_cities` VALUES (1,'Washington','US'),(2,'Amman','JO'),(3,'Pretoria','ZA'),(4,'(Old) Ottawa','CA'),(5,'Plano Piloto','BR'),(6,'Kyiv','UA'),(7,'Paris','FR'),(8,'Moscow','RU'),(9,'Rome','IT'),(10,'Dora','IQ'),(11,'El Hamra','LB'),(12,'Tehran','IR'),(13,'Berlin','DE'),(14,'London','GB'),(15,'Abu Dhabi','AE'),(16,'Riyadh','SA'),(17,'Malé','MV');
/*!40000 ALTER TABLE `dim_cities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dim_weather`
--

DROP TABLE IF EXISTS `dim_weather`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dim_weather` (
  `weather_id` bigint NOT NULL,
  `weather` text,
  `description` text,
  PRIMARY KEY (`weather_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dim_weather`
--

LOCK TABLES `dim_weather` WRITE;
/*!40000 ALTER TABLE `dim_weather` DISABLE KEYS */;
INSERT INTO `dim_weather` VALUES (500,'Rain','light rain'),(501,'Rain','moderate rain'),(502,'Rain','heavy intensity rain'),(800,'Clear','clear sky'),(801,'Clouds','few clouds'),(802,'Clouds','scattered clouds'),(803,'Clouds','broken clouds'),(804,'Clouds','overcast clouds');
/*!40000 ALTER TABLE `dim_weather` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fact_weather_details`
--

DROP TABLE IF EXISTS `fact_weather_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fact_weather_details` (
  `id` bigint NOT NULL,
  `date` datetime DEFAULT NULL,
  `city_id` bigint DEFAULT NULL,
  `summary` text,
  `temp_morn` double DEFAULT NULL,
  `temp_day` double DEFAULT NULL,
  `temp_eve` double DEFAULT NULL,
  `temp_night` double DEFAULT NULL,
  `temp_min` double DEFAULT NULL,
  `temp_max` double DEFAULT NULL,
  `feels_like_morn` double DEFAULT NULL,
  `feels_like_day` double DEFAULT NULL,
  `feels_like_eve` double DEFAULT NULL,
  `feels_like_night` double DEFAULT NULL,
  `pressure` bigint DEFAULT NULL,
  `humidity` bigint DEFAULT NULL,
  `dew_point` double DEFAULT NULL,
  `wind_speed` double DEFAULT NULL,
  `wind_gust` double DEFAULT NULL,
  `clouds` bigint DEFAULT NULL,
  `uvi` double DEFAULT NULL,
  `precep_prob` double DEFAULT NULL,
  `rain` double DEFAULT NULL,
  `weather_id` bigint DEFAULT NULL,
  `extracted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_city_fact_idx` (`city_id`),
  KEY `fk_weather_fact_idx` (`weather_id`),
  CONSTRAINT `fk_city_fact` FOREIGN KEY (`city_id`) REFERENCES `dim_cities` (`city_id`),
  CONSTRAINT `fk_weather_fact` FOREIGN KEY (`weather_id`) REFERENCES `dim_weather` (`weather_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fact_weather_details`
--

LOCK TABLES `fact_weather_details` WRITE;
/*!40000 ALTER TABLE `fact_weather_details` DISABLE KEYS */;
INSERT INTO `fact_weather_details` VALUES (1,'2024-10-17 00:00:00',1,'Expect a day of partly cloudy with clear spells',6.5,13.36,14.94,10.77,6.49,15.68,3.75,12.03,13.4,9.31,1025,49,2.88,4.94,10.6,19,3.46,0,NULL,801,'2024-10-17 00:00:00'),(2,'2024-10-18 00:00:00',1,'There will be clear sky today',9.09,17.47,17.75,13.47,8.86,20.91,7.27,15.95,16.34,11.94,1032,26,-2.31,3.53,10.97,0,3.89,0,NULL,800,'2024-10-17 00:00:00'),(3,'2024-10-19 00:00:00',1,'Expect a day of partly cloudy with clear spells',10.66,19.37,19.12,14.53,10.34,22.2,9.22,18.12,18,13.29,1034,29,0.97,1.67,2.59,0,4,0,NULL,800,'2024-10-17 00:00:00'),(4,'2024-10-20 00:00:00',1,'Expect a day of partly cloudy with clear spells',11.94,20.81,22.81,15.92,11.62,23.15,10.65,19.89,21.93,14.74,1028,36,5.07,2.07,2.97,9,4.01,0,NULL,800,'2024-10-17 00:00:00'),(5,'2024-10-21 00:00:00',1,'There will be clear sky today',13.21,20.34,24.54,18.14,12.88,24.91,12.1,19.4,23.86,17.34,1027,37,5.13,2.04,3.64,0,5,0,NULL,800,'2024-10-17 00:00:00'),(6,'2024-10-22 00:00:00',1,'There will be clear sky today',15.92,22.55,25.86,18.14,15.66,26.53,15.16,21.93,25.47,17.52,1025,41,8.64,1.68,4.28,0,5,0,NULL,800,'2024-10-17 00:00:00'),(7,'2024-10-23 00:00:00',1,'Expect a day of partly cloudy with clear spells',15.17,19.71,24.04,17.77,14.74,24.24,14.47,18.96,23.44,17.14,1019,47,8.04,2.27,5.25,100,5,0,NULL,804,'2024-10-17 00:00:00'),(8,'2024-10-24 00:00:00',1,'You can expect partly cloudy in the morning, with clearing in the afternoon',17.09,17,17.28,12.21,12.21,17.28,16.5,16.22,16,10.71,1017,56,8.12,4.92,10.71,13,5,0,NULL,801,'2024-10-17 00:00:00'),(9,'2024-10-17 00:00:00',2,'You can expect clear sky in the morning, with partly cloudy in the afternoon',15.56,22.1,21.15,18.69,15.5,22.76,15.57,21.59,20.89,18.73,1014,47,10.53,6.75,7.49,0,5.84,0,NULL,800,'2024-10-17 00:00:00'),(10,'2024-10-18 00:00:00',2,'You can expect partly cloudy in the morning, with clearing in the afternoon',15.27,21.42,19.95,15.32,15.27,22.81,15.33,21.03,19.12,14.11,1013,54,12.1,5.86,6.53,19,5.22,0,NULL,801,'2024-10-17 00:00:00'),(11,'2024-10-19 00:00:00',2,'There will be clear sky today',12.11,21.52,19.12,14.62,11.94,22.59,10.81,20.35,17.87,13.39,1015,24,0.19,4.91,4.17,0,5.48,0,NULL,800,'2024-10-17 00:00:00'),(12,'2024-10-20 00:00:00',2,'There will be clear sky today',12.31,23.01,20.59,17.86,12.31,24.86,10.88,21.81,19.28,16.3,1018,17,-3.09,2.91,2.79,0,5.58,0,NULL,800,'2024-10-17 00:00:00'),(13,'2024-10-21 00:00:00',2,'There will be clear sky today',14.56,22.71,19.35,15.65,14.56,22.71,12.88,21.53,18.23,14.52,1017,19,-2.07,5.97,6.62,0,5.65,0,NULL,800,'2024-10-17 00:00:00'),(14,'2024-10-22 00:00:00',2,'There will be clear sky today',12.7,21.22,19.68,17.45,12.7,23.29,10.68,19.79,18.15,15.75,1017,15,-6.43,7.75,10.89,0,6,0,NULL,800,'2024-10-17 00:00:00'),(15,'2024-10-23 00:00:00',2,'There will be clear sky today',11.75,22.16,19.45,16.52,11.75,24.01,9.69,20.82,17.92,14.93,1014,15,-5.2,5.81,9.45,0,6,0,NULL,800,'2024-10-17 00:00:00'),(16,'2024-10-24 00:00:00',2,'You can expect clear sky in the morning, with partly cloudy in the afternoon',12.12,19.89,18.42,15.3,12.12,20.86,11.24,18.9,17.47,14.53,1015,37,5.1,4.75,6.11,0,6,0,NULL,800,'2024-10-17 00:00:00'),(17,'2024-10-17 00:00:00',3,'Expect a day of partly cloudy with clear spells',13.3,21.63,24.84,22.23,13.3,25.85,12.36,20.84,24.27,21.42,1019,38,6.73,4.02,5.54,8,11.06,0,NULL,800,'2024-10-17 00:00:00'),(18,'2024-10-18 00:00:00',3,'Expect a day of partly cloudy with rain',18.78,26.34,29.17,24.48,18.6,30.1,17.78,26.34,27.59,23.74,1012,25,4.74,4.74,8.28,1,11.66,0.28,0.16,500,'2024-10-17 00:00:00'),(19,'2024-10-19 00:00:00',3,'Expect a day of partly cloudy with clear spells',19.75,28.77,31.08,24.89,19.5,31.79,18.77,27.29,29,24.17,1010,20,3.9,6.76,11.3,1,11.72,0,NULL,800,'2024-10-17 00:00:00'),(20,'2024-10-20 00:00:00',3,'Expect a day of partly cloudy with rain',20.12,28.85,27.75,23.4,19.97,31.79,19.31,27.47,26.83,22.81,1012,24,6.33,6.52,11.97,0,11.38,0.33,0.14,500,'2024-10-17 00:00:00'),(21,'2024-10-21 00:00:00',3,'Expect a day of partly cloudy with rain',20.09,26.14,28.92,21.63,20.09,30.46,19.41,26.14,27.53,20.92,1014,34,8.93,9.55,13.59,86,11.93,0.39,0.91,500,'2024-10-17 00:00:00'),(22,'2024-10-22 00:00:00',3,'Expect a day of partly cloudy with rain',19.16,27.36,21.82,19.34,19.16,31.84,18.46,26.69,21.42,19,1014,31,8.77,11.8,16.34,26,12,0.75,0.63,500,'2024-10-17 00:00:00'),(23,'2024-10-23 00:00:00',3,'Expect a day of partly cloudy with clear spells',17.28,27.28,30.56,21.32,17.28,31.13,16.89,26.87,28.7,20.84,1015,36,10.85,4.84,7.56,0,12,0,NULL,800,'2024-10-17 00:00:00'),(24,'2024-10-24 00:00:00',3,'Expect a day of partly cloudy with clear spells',18.13,27.61,31.95,24.22,18.13,31.95,17.93,27.22,29.93,23.56,1015,38,12.13,3.78,5.68,0,12,0,NULL,800,'2024-10-17 00:00:00'),(25,'2024-10-17 00:00:00',4,'Expect a day of partly cloudy with clear spells',1.5,11.51,9.6,5.85,1.37,12.94,-0.94,10.15,9.6,5.85,1025,55,2.79,2.94,3.85,19,2.94,0,NULL,801,'2024-10-17 00:00:00'),(26,'2024-10-18 00:00:00',4,'There will be clear sky today',3.97,13.4,11.98,7.4,3.6,16.65,3.97,11.94,10.54,6.07,1033,44,1.48,2.44,3.38,0,2.97,0,NULL,800,'2024-10-17 00:00:00'),(27,'2024-10-19 00:00:00',4,'There will be clear sky today',5.26,15.69,14.27,8.91,5.02,19.48,3.93,14.52,13.32,7.45,1032,46,3.89,3.89,6.14,0,3.07,0,NULL,800,'2024-10-17 00:00:00'),(28,'2024-10-20 00:00:00',4,'There will be clear sky until morning, then partly cloudy',6.64,17.55,19.06,14.04,6.63,20.08,4.88,16.54,18.14,12.96,1023,45,5.28,6,13.99,60,2.78,0,NULL,803,'2024-10-17 00:00:00'),(29,'2024-10-21 00:00:00',4,'You can expect partly cloudy in the morning, with clearing in the afternoon',11.75,18.61,20.06,13.48,11.31,21.25,10.76,18.07,19.66,13,1021,59,10.38,4.54,12.68,28,3,0,NULL,802,'2024-10-17 00:00:00'),(30,'2024-10-22 00:00:00',4,'There will be partly cloudy today',11.35,18.57,21,12.57,11.35,22.99,10.94,17.92,20.43,11.61,1022,55,9.23,4.36,7.91,56,3,0,NULL,803,'2024-10-17 00:00:00'),(31,'2024-10-23 00:00:00',4,'You can expect partly cloudy in the morning, with rain in the afternoon',11.45,17.24,19.7,9.67,9.67,21.37,10.87,16.61,19.03,6.64,1013,61,9.49,6.59,11.11,99,3,1,3.3,500,'2024-10-17 00:00:00'),(32,'2024-10-24 00:00:00',4,'You can expect partly cloudy in the morning, with clearing in the afternoon',5.61,6.24,7.95,2.44,2.44,8.74,1.69,2.92,5.57,0.54,1020,54,-2.43,6.7,10.13,23,3,0.8,NULL,801,'2024-10-17 00:00:00'),(33,'2024-10-17 00:00:00',5,'Expect a day of partly cloudy with rain',17.89,24.14,22.99,20.82,17.87,24.14,18.16,24.39,23.25,21.07,1014,68,17.87,2.79,5.25,52,12.84,1,19.58,502,'2024-10-17 00:00:00'),(34,'2024-10-18 00:00:00',5,'Expect a day of partly cloudy with rain',18.78,26.57,26.32,21.92,18.78,27.36,19.09,26.57,26.32,22.1,1014,55,16.95,2.27,3.04,100,11.82,0.85,1.48,500,'2024-10-17 00:00:00'),(35,'2024-10-19 00:00:00',5,'Expect a day of partly cloudy with rain',19.52,24.64,23.02,19.2,19.2,24.87,19.72,24.88,23.05,19.19,1012,66,17.87,5.22,6.85,77,12.47,1,9.72,501,'2024-10-17 00:00:00'),(36,'2024-10-20 00:00:00',5,'Expect a day of partly cloudy with rain',18.69,24.66,20.7,19.69,17.7,25.14,18.99,24.9,21.1,20.04,1011,66,17.99,5.1,10.32,97,12.96,1,17.4,501,'2024-10-17 00:00:00'),(37,'2024-10-21 00:00:00',5,'There will be rain today',18.45,21.76,21.44,19.49,18.45,22.93,18.75,22.08,21.81,19.92,1014,80,18.28,4.06,6.47,99,3.52,1,17.32,501,'2024-10-17 00:00:00'),(38,'2024-10-22 00:00:00',5,'Expect a day of partly cloudy with rain',18.36,23.46,21.5,19.75,18.36,24.6,18.71,23.69,21.9,20.1,1016,70,17.81,5.3,11.4,100,4,1,11.12,501,'2024-10-17 00:00:00'),(39,'2024-10-23 00:00:00',5,'Expect a day of partly cloudy with rain',18.72,23.51,20.82,19.42,18.72,24.6,19.05,23.8,21.26,19.87,1014,72,18.27,3.8,7.91,98,4,1,26.91,502,'2024-10-17 00:00:00'),(40,'2024-10-24 00:00:00',5,'You can expect rain in the morning, with partly cloudy in the afternoon',18.92,22.05,21.25,20.54,18.92,24.14,19.35,22.45,21.65,20.76,1013,82,18.78,2.71,4.86,100,4,1,10.17,501,'2024-10-17 00:00:00'),(41,'2024-10-17 00:00:00',6,'Expect a day of partly cloudy with rain',5.57,8.68,7.83,6.73,5.49,9.87,2.8,6.22,5.85,5.03,1034,50,-1.09,4.52,9.7,5,1.84,0.2,0.12,500,'2024-10-17 00:00:00'),(42,'2024-10-18 00:00:00',6,'There will be partly cloudy today',6.16,7.32,7.84,5.13,5.13,8.89,4.01,5.1,5.53,3.21,1031,66,1.46,4.15,7.73,100,1.76,0,NULL,804,'2024-10-17 00:00:00'),(43,'2024-10-19 00:00:00',6,'You can expect partly cloudy in the morning, with clearing in the afternoon',4.06,8.91,8.71,5.89,4.06,10.98,1.69,6.85,6.84,3.9,1030,61,1.87,4.66,7.67,58,1.68,0,NULL,803,'2024-10-17 00:00:00'),(44,'2024-10-20 00:00:00',6,'Expect a day of partly cloudy with clear spells',4.57,8.83,9.08,7.88,4.32,10.88,2.27,6.79,7.79,6.62,1033,52,-0.43,3.55,8.2,14,1.81,0,NULL,801,'2024-10-17 00:00:00'),(45,'2024-10-21 00:00:00',6,'Expect a day of partly cloudy with clear spells',5.34,11,10.5,9.12,5.34,12.84,3.15,9.38,8.96,8.62,1036,47,0.22,3.33,6.97,11,1.83,0,NULL,801,'2024-10-17 00:00:00'),(46,'2024-10-22 00:00:00',6,'There will be partly cloudy today',6.67,11.46,11.1,9.84,6.67,13.02,6.67,9.97,9.81,9.84,1034,50,1.4,1.2,1.2,100,2,0,NULL,804,'2024-10-17 00:00:00'),(47,'2024-10-23 00:00:00',6,'There will be partly cloudy today',7.94,12.81,12.05,10.47,7.94,14.92,7.94,11.66,10.88,9.3,1030,58,4.77,1.4,1.48,92,2,0,NULL,804,'2024-10-17 00:00:00'),(48,'2024-10-24 00:00:00',6,'There will be partly cloudy today',7.77,12.34,11.84,9.72,7.77,14.27,7.77,11.04,10.57,8.55,1031,54,3.55,3.05,6.9,15,2,0,NULL,801,'2024-10-17 00:00:00'),(49,'2024-10-17 00:00:00',7,'Expect a day of partly cloudy with rain',17.6,17.19,16.68,16.01,16.01,18.81,17.53,17.24,16.91,16.07,1012,87,14.78,5.82,11.7,100,0.69,1,8.59,501,'2024-10-17 00:00:00'),(50,'2024-10-18 00:00:00',7,'Expect a day of partly cloudy with rain',14.32,15.28,16.56,15.89,13.98,17.01,14.13,15.08,16.33,15.52,1015,85,12.51,4.61,10.36,100,0.88,1,3.52,501,'2024-10-17 00:00:00'),(51,'2024-10-19 00:00:00',7,'There will be partly cloudy today',13.87,16.12,14.94,14.66,13.16,16.12,13.19,15.54,14.63,14.32,1015,67,9.84,4.01,7.72,100,1.64,0,NULL,804,'2024-10-17 00:00:00'),(52,'2024-10-20 00:00:00',7,'There will be partly cloudy today',12.45,15.9,17.3,16.31,12.35,18.15,11.94,15.32,16.57,15.69,1020,68,9.73,4.91,11.52,100,1.91,0,NULL,804,'2024-10-17 00:00:00'),(53,'2024-10-21 00:00:00',7,'Expect a day of partly cloudy with rain',14.62,15.57,14.67,14.36,14.36,15.75,13.91,15.04,14.33,14.1,1021,71,10.13,3.5,9.94,98,0.35,1,1.25,500,'2024-10-17 00:00:00'),(54,'2024-10-22 00:00:00',7,'Expect a day of partly cloudy with rain',12.71,15.96,14.62,13.51,12.71,16.42,12.31,15,13.63,12.56,1028,53,6.26,3.45,8.53,19,1,1,2.8,500,'2024-10-17 00:00:00'),(55,'2024-10-23 00:00:00',7,'The day will start with partly cloudy through the late morning hours, transitioning to clearing',10.87,15.49,14.22,12.57,10.87,16.19,10.15,14.58,13.39,11.68,1031,57,6.75,3,7.78,0,1,0,NULL,800,'2024-10-17 00:00:00'),(56,'2024-10-24 00:00:00',7,'Expect a day of partly cloudy with clear spells',9.87,15.47,15.5,15.45,9.87,16.33,8.91,14.69,14.7,14.54,1019,62,8.05,3.11,7.86,8,1,0,NULL,800,'2024-10-17 00:00:00'),(57,'2024-10-17 00:00:00',8,'Expect a day of partly cloudy with clear spells',2.41,6.2,6.92,5.2,2.23,7.6,-0.24,4.23,5.53,3.61,1031,63,-0.33,3.7,8.2,16,1.11,0,NULL,801,'2024-10-17 00:00:00'),(58,'2024-10-18 00:00:00',8,'Expect a day of partly cloudy with clear spells',1.59,6.43,6.25,4.22,1.45,8.08,-0.27,5.32,4.99,2.81,1035,58,-1.31,2.18,3.63,10,1.14,0,NULL,800,'2024-10-17 00:00:00'),(59,'2024-10-19 00:00:00',8,'Expect a day of partly cloudy with clear spells',2.47,6.85,7.03,6.35,2.29,8.58,0.75,5.19,5.31,4.54,1033,57,-1.11,3.07,5.76,5,0.91,0,NULL,800,'2024-10-17 00:00:00'),(60,'2024-10-20 00:00:00',8,'There will be partly cloudy today',4.97,9.16,9.18,8.32,4.79,10.58,3.12,6.76,7.11,5.87,1030,51,-0.35,4.91,9.91,43,0.56,0,NULL,802,'2024-10-17 00:00:00'),(61,'2024-10-21 00:00:00',8,'There will be partly cloudy today',7.71,10.02,9.3,8.19,7.49,11.36,6.21,8.41,7.77,6.35,1032,51,0.23,3.29,8.05,66,1.11,0,NULL,803,'2024-10-17 00:00:00'),(62,'2024-10-22 00:00:00',8,'There will be partly cloudy today',7.33,10.2,9.56,8.31,7.02,11.5,4.94,8.56,8.05,6.79,1028,49,-0.18,3.78,9.94,100,2,0,NULL,804,'2024-10-17 00:00:00'),(63,'2024-10-23 00:00:00',8,'There will be partly cloudy today',5.91,10.18,9.78,8.3,5.91,11.84,4.7,8.72,8.89,7.02,1027,56,1.64,2.23,4.81,96,2,0,NULL,804,'2024-10-17 00:00:00'),(64,'2024-10-24 00:00:00',8,'There will be partly cloudy today',6.04,9.49,8.04,6.51,6.04,10.19,3.81,7.13,6.14,5.18,1031,61,2.38,4.56,10.29,69,2,0,NULL,803,'2024-10-17 00:00:00'),(65,'2024-10-17 00:00:00',9,'Expect a day of partly cloudy with rain',20.28,24.71,21.85,18.79,18.79,24.71,20.17,24.57,21.87,19.05,1020,51,14.1,4.59,9.52,87,2.12,1,9.5,502,'2024-10-17 00:00:00'),(66,'2024-10-18 00:00:00',9,'Expect a day of partly cloudy with rain',18.36,21.61,19.88,17.77,17.77,21.72,18.6,21.65,19.75,17.82,1017,70,15.89,3.85,9.81,96,3.39,1,10.6,501,'2024-10-17 00:00:00'),(67,'2024-10-19 00:00:00',9,'Expect a day of partly cloudy with rain',16.35,20.11,19.88,16.69,15.99,21.56,16.42,19.93,19.73,16.74,1013,67,13.93,3.7,7.05,100,1.76,1,13.66,502,'2024-10-17 00:00:00'),(68,'2024-10-20 00:00:00',9,'Expect a day of partly cloudy with rain',16.51,17.6,19.28,16.35,16.31,20.93,16.59,17.64,19.17,16.29,1017,85,15.15,2.83,7.89,100,2.22,1,2.94,500,'2024-10-17 00:00:00'),(69,'2024-10-21 00:00:00',9,'You can expect partly cloudy in the morning, with rain in the afternoon',15.87,20.43,22.83,18.61,15.61,23,15.6,20.15,22.58,18.46,1021,62,12.98,2.75,5.52,81,3.21,0.34,0.46,500,'2024-10-17 00:00:00'),(70,'2024-10-22 00:00:00',9,'Expect a day of partly cloudy with rain',16.78,17.16,22,17.1,16.66,22,16.52,16.97,21.74,16.9,1020,78,13.28,3.19,6.59,98,4,0.67,0.92,500,'2024-10-17 00:00:00'),(71,'2024-10-23 00:00:00',9,'You can expect partly cloudy in the morning, with rain in the afternoon',16.08,18.71,19.46,17.15,15.93,21.68,15.83,18.36,19.26,17.14,1022,66,12.22,2.32,3.32,100,4,0.6,1.17,500,'2024-10-17 00:00:00'),(72,'2024-10-24 00:00:00',9,'Expect a day of partly cloudy with rain',15.38,20.26,21.04,16.99,15.17,22.53,15.3,19.99,20.79,16.89,1020,63,13.09,3.2,3.89,5,4,0.72,1.11,500,'2024-10-17 00:00:00'),(73,'2024-10-17 00:00:00',10,'Expect a day of partly cloudy with clear spells',28.14,36.81,35.84,32.28,28.14,38.98,27.03,34.12,33.33,30.14,1009,12,3.35,6.68,13.16,58,4.97,0,NULL,803,'2024-10-17 00:00:00'),(74,'2024-10-18 00:00:00',10,'There will be clear sky today',26.64,31.8,31.33,25.87,25.81,33.43,26.64,30.38,29.26,24.88,1007,28,11.24,7.96,13.8,0,5,0,NULL,800,'2024-10-17 00:00:00'),(75,'2024-10-19 00:00:00',10,'There will be clear sky today',22.68,29.1,30.31,25.24,22.48,31.56,21.37,27.44,28.4,24.26,1014,13,-1.89,6.23,10.01,0,5.15,0,NULL,800,'2024-10-17 00:00:00'),(76,'2024-10-20 00:00:00',10,'There will be clear sky today',22.66,29.13,28.65,24.36,22.35,30.65,21.48,27.46,27.1,23.09,1016,12,-2.64,7.53,9.92,0,5.21,0,NULL,800,'2024-10-17 00:00:00'),(77,'2024-10-21 00:00:00',10,'There will be clear sky today',19.54,27.81,25.62,23.47,19.54,28.88,17.86,26.46,24.58,22.24,1014,9,-7.84,5.91,8.7,0,5.33,0,NULL,800,'2024-10-17 00:00:00'),(78,'2024-10-22 00:00:00',10,'You can expect clear sky in the morning, with partly cloudy in the afternoon',19.32,25.72,23.46,22.06,19.32,26.18,17.86,24.71,22.2,20.71,1014,14,-3.83,7.21,7.8,0,6,0,NULL,800,'2024-10-17 00:00:00'),(79,'2024-10-23 00:00:00',10,'You can expect clear sky in the morning, with partly cloudy in the afternoon',17.7,26.04,24.85,22.58,17.7,27.47,16.2,26.04,23.7,21.31,1015,14,-3.66,4.94,7.53,1,6,0,NULL,800,'2024-10-17 00:00:00'),(80,'2024-10-24 00:00:00',10,'There will be partly cloudy until morning, then clearing',18.78,27.3,25.66,23.08,18.78,28.81,17.11,26.07,24.49,21.73,1014,9,-8.35,4.31,5.24,0,6,0,NULL,800,'2024-10-17 00:00:00'),(81,'2024-10-17 00:00:00',11,'Expect a day of partly cloudy with rain',23.21,24.41,25.15,24.64,23.06,25.61,23.41,24.66,25.47,24.99,1014,67,17.88,4.56,4.37,0,4.97,0.84,0.3,500,'2024-10-17 00:00:00'),(82,'2024-10-18 00:00:00',11,'Expect a day of partly cloudy with rain',24.26,24,23.26,23.07,23.07,24.48,24.1,23.71,22.95,22.66,1013,48,12.41,6.81,7.32,0,5.16,1,1.47,501,'2024-10-17 00:00:00'),(83,'2024-10-19 00:00:00',11,'There will be clear sky today',22.22,23.3,23.2,22.8,22.19,23.4,21.72,22.83,22.8,22.44,1016,44,10.61,6.56,6.9,0,5.19,0,NULL,800,'2024-10-17 00:00:00'),(84,'2024-10-20 00:00:00',11,'There will be clear sky today',21.99,23.15,23.89,23.52,21.93,23.9,21.63,22.64,23.41,23.15,1018,43,10.21,5.96,6.27,0,5.1,0,NULL,800,'2024-10-17 00:00:00'),(85,'2024-10-21 00:00:00',11,'There will be clear sky today',23.15,24.18,23.92,23.7,23.15,24.18,22.83,23.8,23.57,23.35,1017,44,11.35,6.83,7.44,0,5.11,0,NULL,800,'2024-10-17 00:00:00'),(86,'2024-10-22 00:00:00',11,'The day will start with clear sky through the late morning hours, transitioning to partly cloudy',23.11,23.84,24.82,24.71,23.11,24.82,22.21,23.25,24.25,24.18,1018,37,8.28,6.31,5.95,100,6,0,NULL,804,'2024-10-17 00:00:00'),(87,'2024-10-23 00:00:00',11,'Expect a day of partly cloudy with clear spells',22.94,23.61,23.28,23.08,22.94,23.98,22.1,23.04,22.73,22.51,1015,39,9.3,3.94,3.98,29,6,0,NULL,802,'2024-10-17 00:00:00'),(88,'2024-10-24 00:00:00',11,'You can expect clear sky in the morning, with partly cloudy in the afternoon',22.3,23.64,23.8,23.58,22.3,23.92,21.66,23.16,23.28,23.06,1015,42,10.25,2.27,1.92,3,6,0,NULL,800,'2024-10-17 00:00:00'),(89,'2024-10-17 00:00:00',12,'Expect a day of partly cloudy with clear spells',22.01,23.42,24.96,23.07,21.72,25.65,21.05,22.6,24.11,22.11,1016,30,4.47,2.85,2.95,2,5.39,0,NULL,800,'2024-10-17 00:00:00'),(90,'2024-10-18 00:00:00',12,'The day will start with clear sky through the late morning hours, transitioning to partly cloudy',22.3,24.73,27.19,24.93,21.94,27.34,21.29,23.86,26.11,23.97,1014,23,1.61,3.05,4.14,67,5.2,0,NULL,803,'2024-10-17 00:00:00'),(91,'2024-10-19 00:00:00',12,'You can expect partly cloudy in the morning, with clearing in the afternoon',23.43,25.17,27.45,24.4,22.68,27.57,22.35,24.21,26.22,23.34,1014,18,-0.94,6.82,10.17,64,4.93,0,NULL,803,'2024-10-17 00:00:00'),(92,'2024-10-20 00:00:00',12,'There will be clear sky today',21.68,23.2,24.59,23.54,20.87,24.78,20.5,22.05,23.5,22.29,1015,18,-2.56,6.96,11.33,0,5.54,0,NULL,800,'2024-10-17 00:00:00'),(93,'2024-10-21 00:00:00',12,'Expect a day of partly cloudy with clear spells',20.83,21.03,23.86,21.65,19.8,23.86,19.44,19.74,22.64,20.34,1014,21,-2.35,3.94,5.24,19,5,0,NULL,801,'2024-10-17 00:00:00'),(94,'2024-10-22 00:00:00',12,'Expect a day of partly cloudy with clear spells',17.82,18.16,19.45,14.92,14.92,19.84,16.49,16.79,17.89,13.2,1011,29,-0.34,6.46,8.21,56,5,0,NULL,803,'2024-10-17 00:00:00'),(95,'2024-10-23 00:00:00',12,'Expect a day of partly cloudy with clear spells',12.41,12.96,15.02,13.95,11.86,15.02,10.62,11.3,13.47,12.34,1021,38,-1.73,3.35,3.83,1,5,0,NULL,800,'2024-10-17 00:00:00'),(96,'2024-10-24 00:00:00',12,'You can expect partly cloudy in the morning, with clearing in the afternoon',12.73,12.64,15.48,14.74,12.14,15.48,11.08,11.03,13.84,13,1022,41,-0.95,2.73,2.69,100,5,0,NULL,804,'2024-10-17 00:00:00'),(97,'2024-10-17 00:00:00',13,'Expect a day of partly cloudy with clear spells',9.59,14.36,14.62,13.04,9.3,16.7,6.72,13.24,13.91,12.2,1018,53,4.82,6.28,17.04,75,1.66,0,NULL,803,'2024-10-17 00:00:00'),(98,'2024-10-18 00:00:00',13,'Expect a day of partly cloudy with clear spells',10.83,14.46,15.14,13.16,10.6,17.02,9.8,13.4,14.2,12.18,1017,55,5.6,5.64,11.65,100,1.63,0,NULL,804,'2024-10-17 00:00:00'),(99,'2024-10-19 00:00:00',13,'There will be partly cloudy today',10.9,15.81,16.46,13.27,10.79,19.04,9.82,15.07,15.88,12.64,1017,62,8.5,4.91,11.11,97,1.64,0,NULL,804,'2024-10-17 00:00:00'),(100,'2024-10-20 00:00:00',13,'There will be partly cloudy today',10.86,15.05,15.11,11.73,10.51,17.93,9.72,13.66,13.83,10.42,1024,40,1.51,5.38,10.78,100,1.41,0,NULL,804,'2024-10-17 00:00:00'),(101,'2024-10-21 00:00:00',13,'You can expect partly cloudy in the morning, with clearing in the afternoon',9.32,13.45,17.48,11.92,9.04,17.48,7.39,12.37,16.72,10.63,1025,58,5.4,3.72,9.48,87,1.31,0,NULL,804,'2024-10-17 00:00:00'),(102,'2024-10-22 00:00:00',13,'You can expect clear sky in the morning, with partly cloudy in the afternoon',9.34,12.48,16.54,13.07,8.5,16.59,7.97,11.14,15.61,12.34,1022,52,3,2.78,6.3,0,2,0,NULL,800,'2024-10-17 00:00:00'),(103,'2024-10-23 00:00:00',13,'Expect a day of partly cloudy with rain',11.37,11.09,12.67,10.58,10.58,12.67,10.89,10.63,12.08,9.86,1031,91,9.64,4.05,7.9,100,2,1,2.01,500,'2024-10-17 00:00:00'),(104,'2024-10-24 00:00:00',13,'There will be partly cloudy today',10.08,11.75,14.22,10.61,10.02,14.6,9.18,10.78,13.34,9.53,1030,69,6.23,5.18,11.61,99,2,0,NULL,804,'2024-10-17 00:00:00'),(105,'2024-10-17 00:00:00',14,'There will be rain until morning, then partly cloudy',15.33,16.53,16.87,12.98,12.98,17.19,15.4,15.94,16.47,12.63,1011,65,9.98,3.85,9.86,76,1.59,1,2.12,501,'2024-10-17 00:00:00'),(106,'2024-10-18 00:00:00',14,'Expect a day of partly cloudy with clear spells',10.97,15.24,14.73,12.78,10.76,17.2,10.52,14.49,13.96,12.25,1015,64,8.46,3.58,9.32,4,1.81,0,NULL,800,'2024-10-17 00:00:00'),(107,'2024-10-19 00:00:00',14,'Expect a day of partly cloudy with rain',13.23,14.04,14.17,11.87,11.87,14.29,12.98,13.98,14.12,11.46,1011,95,13.13,3.69,9.51,100,0.25,1,6.09,500,'2024-10-17 00:00:00'),(108,'2024-10-20 00:00:00',14,'Expect a day of partly cloudy with rain',11.21,13.73,15.64,14.81,10.67,16.28,10.63,13.22,15.58,14.57,1012,79,10.1,8.4,18.8,100,1.29,0.8,0.77,500,'2024-10-17 00:00:00'),(109,'2024-10-21 00:00:00',14,'Expect a day of partly cloudy with rain',12.64,15.15,13.15,11.97,11.97,15.15,12.28,14.44,12.43,11.26,1020,66,8.83,3.45,9.42,100,1.1,1,1.73,500,'2024-10-17 00:00:00'),(110,'2024-10-22 00:00:00',14,'Expect a day of partly cloudy with clear spells',9.12,14.76,13.03,11.8,9.12,15.31,8.28,13.91,12.35,11.23,1026,62,7.6,3.73,7.21,0,2,0,NULL,800,'2024-10-17 00:00:00'),(111,'2024-10-23 00:00:00',14,'There will be partly cloudy today',11.53,14.21,13.02,11.6,10.69,15.95,11.11,13.75,12.52,11.17,1030,79,10.6,2.61,7.9,100,2,0,NULL,804,'2024-10-17 00:00:00'),(112,'2024-10-24 00:00:00',14,'Expect a day of partly cloudy with clear spells',9.66,14.91,12.66,13.42,9.66,14.91,8.62,14.13,11.91,12.46,1019,64,8.06,4.07,8.93,8,2,0,NULL,800,'2024-10-17 00:00:00'),(113,'2024-10-17 00:00:00',15,'Expect a day of partly cloudy with clear spells',28.38,30.85,31.3,31.57,28.34,32.05,31.42,34.53,38.3,38.51,1010,60,22.22,8.61,10.89,2,8.03,0,NULL,800,'2024-10-17 00:00:00'),(114,'2024-10-18 00:00:00',15,'There will be partly cloudy until morning, then clearing',29.67,30.38,30.99,30.9,29.62,31.28,32.98,33.15,37.88,37.9,1009,58,21.42,5.86,6.72,0,7.69,0,NULL,800,'2024-10-17 00:00:00'),(115,'2024-10-19 00:00:00',15,'There will be clear sky today',30.51,31.23,31.08,31.04,30.38,31.41,36.87,36.43,38.08,37.71,1010,64,23.82,5.56,6.65,3,7.57,0,NULL,800,'2024-10-17 00:00:00'),(116,'2024-10-20 00:00:00',15,'There will be clear sky today',30.65,31.18,30.93,30.76,30.49,31.39,36.96,35.23,36.54,36.68,1010,60,22.61,5.18,6.01,2,7.6,0,NULL,800,'2024-10-17 00:00:00'),(117,'2024-10-21 00:00:00',15,'There will be clear sky today',29.53,30.94,30.81,30.63,29.53,30.94,33.71,35.22,37.81,37.63,1009,62,22.89,6.97,8.34,0,7.09,0,NULL,800,'2024-10-17 00:00:00'),(118,'2024-10-22 00:00:00',15,'There will be clear sky today',30.02,30.66,30.52,30.46,30.02,30.73,35.33,34.61,36.61,35.92,1010,62,22.76,5.33,6.52,2,8,0,NULL,800,'2024-10-17 00:00:00'),(119,'2024-10-23 00:00:00',15,'There will be clear sky today',29.97,30.87,30.27,30.17,29.97,30.87,33.82,33.42,35.45,35.21,1011,55,20.87,5.47,6.68,0,8,0,NULL,800,'2024-10-17 00:00:00'),(120,'2024-10-24 00:00:00',15,'There will be clear sky today',29.62,30.15,30.12,29.96,29.62,30.41,33.08,32.72,34.61,34.47,1011,58,21.37,5.25,5.76,0,8,0,NULL,800,'2024-10-17 00:00:00'),(121,'2024-10-17 00:00:00',16,'There will be clear sky today',25.35,32.54,31.43,28.26,24.78,33.58,24.52,30.23,29.29,26.86,1013,13,0.8,4.46,6.3,0,7.88,0,NULL,800,'2024-10-17 00:00:00'),(122,'2024-10-18 00:00:00',16,'There will be clear sky today',24.35,33.38,33.78,28.67,24.23,35.35,23.52,30.99,31.36,27.24,1011,14,2.22,4.48,6.72,0,7.93,0,NULL,800,'2024-10-17 00:00:00'),(123,'2024-10-19 00:00:00',16,'There will be clear sky today',25.7,33.97,33.95,28.35,25.4,35.35,25.03,31.58,31.61,27.04,1012,15,4.16,4.92,7.77,0,7.89,0,NULL,800,'2024-10-17 00:00:00'),(124,'2024-10-20 00:00:00',16,'There will be clear sky today',26.07,34.22,34.06,30.73,25.55,35.7,26.07,31.69,31.58,28.74,1013,12,1.08,4.35,6.36,0,7.97,0,NULL,800,'2024-10-17 00:00:00'),(125,'2024-10-21 00:00:00',16,'There will be clear sky today',25.63,36.23,33.76,31.12,25.63,36.84,24.85,33.49,31.31,29.05,1011,11,1.19,4.04,5.62,0,7.85,0,NULL,800,'2024-10-17 00:00:00'),(126,'2024-10-22 00:00:00',16,'There will be clear sky today',25.37,34.93,33.13,30.32,25.37,37.03,24.54,32.34,30.74,28.41,1011,12,1.06,4.93,10.31,0,8,0,NULL,800,'2024-10-17 00:00:00'),(127,'2024-10-23 00:00:00',16,'There will be partly cloudy until morning, then clearing',21.48,30.8,31.06,28.95,21.48,33.75,21.17,29.29,29.22,27.78,1013,27,9.53,6.67,12.19,1,8,0,NULL,800,'2024-10-17 00:00:00'),(128,'2024-10-24 00:00:00',16,'There will be clear sky today',24.53,36.18,32.85,30.83,24.53,36.98,24.03,33.67,30.62,28.9,1010,14,4.97,6.98,12.84,1,8,0,NULL,800,'2024-10-17 00:00:00'),(129,'2024-10-17 00:00:00',17,'There will be partly cloudy today',28.35,28.41,28.36,28.84,28.33,28.99,31.67,32.12,32,34.72,1011,74,23.25,7.74,8.74,41,12.31,0,NULL,802,'2024-10-17 00:00:00'),(130,'2024-10-18 00:00:00',17,'Expect a day of partly cloudy with rain',27.93,28.61,28.52,27.73,27.73,28.74,31.48,32.23,32.54,31.43,1010,72,23.12,6.84,7.81,36,12.25,0.34,0.63,500,'2024-10-17 00:00:00'),(131,'2024-10-19 00:00:00',17,'Expect a day of partly cloudy with rain',28.06,28.39,28.3,27.99,27.91,28.53,31.2,31.59,32.03,31.19,1012,71,22.72,7.96,8.05,74,9.68,0.99,0.57,500,'2024-10-17 00:00:00'),(132,'2024-10-20 00:00:00',17,'Expect a day of partly cloudy with clear spells',27.82,27.96,28.06,28.01,27.7,28.24,30.7,30.46,30.92,30.69,1012,69,21.84,5.62,5.62,33,7.39,0,NULL,802,'2024-10-17 00:00:00'),(133,'2024-10-21 00:00:00',17,'There will be partly cloudy today',28.11,28.1,28.35,28.04,27.94,28.35,30.61,30.72,31.21,31.02,1013,69,21.92,4.65,5.14,44,11.76,0,NULL,802,'2024-10-17 00:00:00'),(134,'2024-10-22 00:00:00',17,'Expect a day of partly cloudy with rain',27.71,27.92,27.98,28,27.71,28.32,30.48,30.77,30.89,31.07,1013,72,22.33,4.67,5,51,12,0.2,0.12,500,'2024-10-17 00:00:00'),(135,'2024-10-23 00:00:00',17,'Expect a day of partly cloudy with rain',27.81,27.94,28.18,28.21,27.66,28.21,30.68,31.09,32.07,31.98,1012,74,22.97,6.51,6.57,64,12,1,2.31,500,'2024-10-17 00:00:00'),(136,'2024-10-24 00:00:00',17,'Expect a day of partly cloudy with rain',28.09,28.27,28.2,28.21,28.02,28.52,31.26,32.12,31.96,32.14,1012,76,23.62,6.9,7.5,95,12,1,1.68,500,'2024-10-17 00:00:00');
/*!40000 ALTER TABLE `fact_weather_details` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-10-19 21:54:00
