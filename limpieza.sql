-- MySQL dump 10.13  Distrib 8.0.42, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: prueba
-- ------------------------------------------------------
-- Server version	8.0.42

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
-- Table structure for table `actividad`
--

DROP TABLE IF EXISTS `actividad`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `actividad` (
  `IdActividad` int NOT NULL AUTO_INCREMENT,
  `NombreActi` varchar(150) NOT NULL,
  `FechaInicio` date NOT NULL,
  `FechaFin` date NOT NULL,
  `HoraInicio` time NOT NULL,
  `HoraFin` time NOT NULL,
  `TipoLudica` varchar(255) DEFAULT NULL,
  `Descripcion` text,
  `Imagen` varchar(255) DEFAULT NULL,
  `Ubicacion` varchar(150) DEFAULT NULL,
  `CodigoQR` text,
  `CodigoQRSalida` text,
  `IdEvento` int DEFAULT NULL,
  `IdUsuario` int DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `HorarioContinuo` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`IdActividad`),
  KEY `FK_Actividad_Evento` (`IdEvento`),
  KEY `FK_Actividad_Usuario` (`IdUsuario`),
  CONSTRAINT `FK_Actividad_Evento` FOREIGN KEY (`IdEvento`) REFERENCES `evento` (`IdEvento`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `FK_Actividad_Usuario` FOREIGN KEY (`IdUsuario`) REFERENCES `usuario` (`IdUsuario`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `actividad`
--

LOCK TABLES `actividad` WRITE;
/*!40000 ALTER TABLE `actividad` DISABLE KEYS */;
/*!40000 ALTER TABLE `actividad` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `alquilerelementos`
--

DROP TABLE IF EXISTS `alquilerelementos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `alquilerelementos` (
  `IdAlquiler` int NOT NULL AUTO_INCREMENT,
  `CantidadDisponible` int DEFAULT '1',
  `NombreElemento` varchar(50) NOT NULL,
  `FechaSolicitud` datetime NOT NULL,
  `FechaDevolucion` datetime NOT NULL,
  `RegistradoPor` varchar(50) NOT NULL,
  `Observaciones` text,
  `Imagen` varchar(255) DEFAULT NULL,
  `IdUsuario` int DEFAULT NULL,
  `IdElemento` int DEFAULT NULL,
  `CumplioConEntrega` tinyint(1) DEFAULT '0',
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`IdAlquiler`),
  KEY `IdUsuario` (`IdUsuario`),
  KEY `IdElemento` (`IdElemento`),
  CONSTRAINT `alquilerelementos_ibfk_1` FOREIGN KEY (`IdUsuario`) REFERENCES `usuario` (`IdUsuario`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `alquilerelementos_ibfk_2` FOREIGN KEY (`IdElemento`) REFERENCES `elemento` (`IdElemento`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alquilerelementos`
--

LOCK TABLES `alquilerelementos` WRITE;
/*!40000 ALTER TABLE `alquilerelementos` DISABLE KEYS */;
/*!40000 ALTER TABLE `alquilerelementos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `aprendiz`
--

DROP TABLE IF EXISTS `aprendiz`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `aprendiz` (
  `IdUsuario` int NOT NULL,
  `IdRolUsuario` int DEFAULT NULL,
  `Ficha` varchar(255) DEFAULT NULL,
  `Jornada` varchar(255) DEFAULT NULL,
  `ProgramaFormacion` varchar(255) DEFAULT NULL,
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`IdUsuario`),
  KEY `FK_Aprendiz_RolUsuario` (`IdRolUsuario`),
  CONSTRAINT `FK_Aprendiz_RolUsuario` FOREIGN KEY (`IdRolUsuario`) REFERENCES `rolusuario` (`IdRol`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `FK_Aprendiz_Usuario` FOREIGN KEY (`IdUsuario`) REFERENCES `usuario` (`IdUsuario`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `aprendiz`
--

LOCK TABLES `aprendiz` WRITE;
/*!40000 ALTER TABLE `aprendiz` DISABLE KEYS */;
/*!40000 ALTER TABLE `aprendiz` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `asistencia`
--

DROP TABLE IF EXISTS `asistencia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `asistencia` (
  `AsiId` int NOT NULL AUTO_INCREMENT,
  `AsiFecha` datetime NOT NULL,
  `AsiHorasAsistidas` float DEFAULT '0',
  `QREntrada` datetime DEFAULT NULL,
  `QRSalida` datetime DEFAULT NULL,
  `tipo` varchar(20) DEFAULT NULL,
  `AsiEntrada` tinyint(1) DEFAULT NULL,
  `AsiHoraEntrada` datetime DEFAULT NULL,
  `AsiEstado` varchar(20) DEFAULT 'Incompleta',
  `IdUsuario` int NOT NULL,
  `IdActividad` int DEFAULT NULL,
  `IdRegistradorEntrada` int DEFAULT NULL,
  `IdRegistradorSalida` int DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `IdPlanificarE` int DEFAULT NULL,
  PRIMARY KEY (`AsiId`),
  KEY `FK_Asistencia_Usuario` (`IdUsuario`),
  KEY `FK_Asistencia_Actividad` (`IdActividad`),
  KEY `FK_Asistencia_RegistradorEntrada` (`IdRegistradorEntrada`),
  KEY `FK_Asistencia_RegistradorSalida` (`IdRegistradorSalida`),
  KEY `IdPlanificarE` (`IdPlanificarE`),
  CONSTRAINT `asistencia_ibfk_1` FOREIGN KEY (`IdPlanificarE`) REFERENCES `planificacionevento` (`IdPlanificarE`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `FK_Asistencia_Actividad` FOREIGN KEY (`IdActividad`) REFERENCES `actividad` (`IdActividad`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_Asistencia_RegistradorEntrada` FOREIGN KEY (`IdRegistradorEntrada`) REFERENCES `usuario` (`IdUsuario`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `FK_Asistencia_RegistradorSalida` FOREIGN KEY (`IdRegistradorSalida`) REFERENCES `usuario` (`IdUsuario`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `FK_Asistencia_Usuario` FOREIGN KEY (`IdUsuario`) REFERENCES `usuario` (`IdUsuario`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `asistencia`
--

LOCK TABLES `asistencia` WRITE;
/*!40000 ALTER TABLE `asistencia` DISABLE KEYS */;
/*!40000 ALTER TABLE `asistencia` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comentariosia`
--

DROP TABLE IF EXISTS `comentariosia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `comentariosia` (
  `IdComentario` int NOT NULL AUTO_INCREMENT,
  `Comentario` text NOT NULL,
  `RecomendacionIA` varchar(255) DEFAULT NULL,
  `ComentarioNormalizado` text,
  `IdUsuario` int DEFAULT NULL,
  `IdEvento` int DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`IdComentario`),
  KEY `FK_ComentariosIA_Usuario` (`IdUsuario`),
  KEY `FK_ComentariosIA_Evento` (`IdEvento`),
  CONSTRAINT `FK_ComentariosIA_Evento` FOREIGN KEY (`IdEvento`) REFERENCES `evento` (`IdEvento`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `FK_ComentariosIA_Usuario` FOREIGN KEY (`IdUsuario`) REFERENCES `usuario` (`IdUsuario`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comentariosia`
--

LOCK TABLES `comentariosia` WRITE;
/*!40000 ALTER TABLE `comentariosia` DISABLE KEYS */;
/*!40000 ALTER TABLE `comentariosia` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `confirmacionasistencia`
--

DROP TABLE IF EXISTS `confirmacionasistencia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `confirmacionasistencia` (
  `IdConfirmacion` int NOT NULL AUTO_INCREMENT,
  `Confirmado` tinyint(1) DEFAULT '0',
  `IdUsuario` int NOT NULL,
  `IdEvento` int NOT NULL,
  `Confirmacion` enum('Asistiré','No asistiré','Tal vez') NOT NULL,
  `FechaConfirmacion` datetime DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`IdConfirmacion`),
  KEY `FK_ConfirmacionAsistencia_Usuario` (`IdUsuario`),
  KEY `FK_ConfirmacionAsistencia_Evento` (`IdEvento`),
  CONSTRAINT `FK_ConfirmacionAsistencia_Evento` FOREIGN KEY (`IdEvento`) REFERENCES `evento` (`IdEvento`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_ConfirmacionAsistencia_Usuario` FOREIGN KEY (`IdUsuario`) REFERENCES `usuario` (`IdUsuario`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `confirmacionasistencia`
--

LOCK TABLES `confirmacionasistencia` WRITE;
/*!40000 ALTER TABLE `confirmacionasistencia` DISABLE KEYS */;
/*!40000 ALTER TABLE `confirmacionasistencia` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `constancia`
--

DROP TABLE IF EXISTS `constancia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `constancia` (
  `ConstanciaId` int NOT NULL AUTO_INCREMENT,
  `ConstanciaHorasCert` int NOT NULL,
  `ConstanciaEstado` enum('Aprobado','Pendiente') NOT NULL,
  `ConstanciaFecha` datetime NOT NULL,
  `IdUsuario` int NOT NULL,
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ConstanciaId`),
  KEY `FK_Constancia_Usuario` (`IdUsuario`),
  CONSTRAINT `FK_Constancia_Usuario` FOREIGN KEY (`IdUsuario`) REFERENCES `usuario` (`IdUsuario`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `constancia`
--

LOCK TABLES `constancia` WRITE;
/*!40000 ALTER TABLE `constancia` DISABLE KEYS */;
/*!40000 ALTER TABLE `constancia` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `consultaia`
--

DROP TABLE IF EXISTS `consultaia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `consultaia` (
  `IdConsultaIA` int NOT NULL AUTO_INCREMENT,
  `Pregunta` text NOT NULL,
  `Respuesta` text NOT NULL,
  `Fecha` date NOT NULL,
  `Descripcion` text,
  `IdUsuario` int NOT NULL,
  PRIMARY KEY (`IdConsultaIA`),
  KEY `FK_ConsultaIA_Usuario` (`IdUsuario`),
  CONSTRAINT `FK_ConsultaIA_Usuario` FOREIGN KEY (`IdUsuario`) REFERENCES `usuario` (`IdUsuario`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `consultaia`
--

LOCK TABLES `consultaia` WRITE;
/*!40000 ALTER TABLE `consultaia` DISABLE KEYS */;
/*!40000 ALTER TABLE `consultaia` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `elemento`
--

DROP TABLE IF EXISTS `elemento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `elemento` (
  `IdElemento` int NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(100) NOT NULL,
  `Descripcion` text,
  `Imagen` varchar(255) DEFAULT NULL,
  `Disponible` tinyint(1) DEFAULT '1',
  `CantidadTotal` int NOT NULL DEFAULT '1',
  `CantidadDisponible` int NOT NULL DEFAULT '1',
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`IdElemento`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `elemento`
--

LOCK TABLES `elemento` WRITE;
/*!40000 ALTER TABLE `elemento` DISABLE KEYS */;
/*!40000 ALTER TABLE `elemento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `evento`
--

DROP TABLE IF EXISTS `evento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `evento` (
  `IdEvento` int NOT NULL AUTO_INCREMENT,
  `NombreEvento` varchar(255) NOT NULL,
  `FechaInicio` date NOT NULL,
  `FechaFin` date NOT NULL,
  `HoraInicio` time NOT NULL,
  `HoraFin` time NOT NULL,
  `UbicacionEvento` varchar(255) NOT NULL,
  `IdPlanificarE` int DEFAULT NULL,
  `DescripcionEvento` text,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `QREntrada` text,
  `QRSalida` text,
  `IdUsuario` int DEFAULT NULL,
  PRIMARY KEY (`IdEvento`),
  UNIQUE KEY `IdPlanificarE` (`IdPlanificarE`),
  KEY `FK_Evento_Usuario` (`IdUsuario`),
  CONSTRAINT `FK_Evento_Planificacion` FOREIGN KEY (`IdPlanificarE`) REFERENCES `planificacionevento` (`IdPlanificarE`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `FK_Evento_Usuario` FOREIGN KEY (`IdUsuario`) REFERENCES `usuario` (`IdUsuario`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `evento`
--

LOCK TABLES `evento` WRITE;
/*!40000 ALTER TABLE `evento` DISABLE KEYS */;
/*!40000 ALTER TABLE `evento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `eventoactividad`
--

DROP TABLE IF EXISTS `eventoactividad`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eventoactividad` (
  `id` int NOT NULL AUTO_INCREMENT,
  `IdPlanificarE` int NOT NULL,
  `IdActividad` int NOT NULL,
  `createdAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `IdPlanificarE` (`IdPlanificarE`),
  KEY `IdActividad` (`IdActividad`),
  CONSTRAINT `eventoactividad_ibfk_1` FOREIGN KEY (`IdPlanificarE`) REFERENCES `planificacionevento` (`IdPlanificarE`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `eventoactividad_ibfk_2` FOREIGN KEY (`IdActividad`) REFERENCES `actividad` (`IdActividad`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eventoactividad`
--

LOCK TABLES `eventoactividad` WRITE;
/*!40000 ALTER TABLE `eventoactividad` DISABLE KEYS */;
/*!40000 ALTER TABLE `eventoactividad` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `feedback`
--

DROP TABLE IF EXISTS `feedback`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `feedback` (
  `IdFeedback` int NOT NULL AUTO_INCREMENT,
  `ComentarioFeedback` text NOT NULL,
  `FechaEnvio` datetime DEFAULT NULL,
  `Calificacion` int DEFAULT NULL,
  `IdEvento` int DEFAULT NULL,
  `IdActividad` int DEFAULT NULL,
  `IdUsuario` int NOT NULL,
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `IdSolicitud` int DEFAULT NULL,
  PRIMARY KEY (`IdFeedback`),
  KEY `FK_Feedback_Evento` (`IdEvento`),
  KEY `FK_Feedback_Actividad` (`IdActividad`),
  KEY `FK_Feedback_Usuario` (`IdUsuario`),
  KEY `fk_feedback_solicitud` (`IdSolicitud`),
  CONSTRAINT `FK_Feedback_Actividad` FOREIGN KEY (`IdActividad`) REFERENCES `actividad` (`IdActividad`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `FK_Feedback_Evento` FOREIGN KEY (`IdEvento`) REFERENCES `evento` (`IdEvento`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_feedback_solicitud` FOREIGN KEY (`IdSolicitud`) REFERENCES `solicitudapoyo` (`IdSolicitud`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `FK_Feedback_Usuario` FOREIGN KEY (`IdUsuario`) REFERENCES `usuario` (`IdUsuario`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `feedback`
--

LOCK TABLES `feedback` WRITE;
/*!40000 ALTER TABLE `feedback` DISABLE KEYS */;
/*!40000 ALTER TABLE `feedback` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gestionevento`
--

DROP TABLE IF EXISTS `gestionevento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gestionevento` (
  `IdGestionE` int NOT NULL AUTO_INCREMENT,
  `Aprobar` enum('Aprobado','Pendiente','Rechazado') NOT NULL,
  `createdAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `MotivoRechazo` text,
  `IdUsuario` int DEFAULT NULL,
  PRIMARY KEY (`IdGestionE`),
  KEY `FK_GestionEvento_Usuario` (`IdUsuario`),
  CONSTRAINT `FK_GestionEvento_Usuario` FOREIGN KEY (`IdUsuario`) REFERENCES `usuario` (`IdUsuario`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gestionevento`
--

LOCK TABLES `gestionevento` WRITE;
/*!40000 ALTER TABLE `gestionevento` DISABLE KEYS */;
/*!40000 ALTER TABLE `gestionevento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `historialsolicitud`
--

DROP TABLE IF EXISTS `historialsolicitud`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `historialsolicitud` (
  `IdHistorial` int NOT NULL AUTO_INCREMENT,
  `IdSolicitud` int NOT NULL,
  `EstadoNuevo` enum('Pendiente','En Proceso','Atendido','Finalizado') NOT NULL,
  `Comentario` text,
  `IdUsuario` int NOT NULL,
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`IdHistorial`),
  KEY `FK_HistorialSolicitud_Solicitud` (`IdSolicitud`),
  KEY `FK_HistorialSolicitud_Usuario` (`IdUsuario`),
  CONSTRAINT `FK_HistorialSolicitud_Solicitud` FOREIGN KEY (`IdSolicitud`) REFERENCES `solicitudapoyo` (`IdSolicitud`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_HistorialSolicitud_Usuario` FOREIGN KEY (`IdUsuario`) REFERENCES `usuario` (`IdUsuario`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `historialsolicitud`
--

LOCK TABLES `historialsolicitud` WRITE;
/*!40000 ALTER TABLE `historialsolicitud` DISABLE KEYS */;
/*!40000 ALTER TABLE `historialsolicitud` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notificaciones`
--

DROP TABLE IF EXISTS `notificaciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notificaciones` (
  `IdNotificacion` int NOT NULL AUTO_INCREMENT,
  `Titulo` varchar(100) NOT NULL,
  `Mensaje` text NOT NULL,
  `TipoNotificacion` varchar(20) DEFAULT NULL,
  `FechaDeEnvio` date NOT NULL,
  `IdEvento` int DEFAULT NULL,
  `RutaDestino` varchar(255) DEFAULT NULL,
  `imagenUrl` varchar(255) DEFAULT NULL,
  `IdUsuario` int NOT NULL,
  `Confirmado` tinyint(1) NOT NULL DEFAULT '0',
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`IdNotificacion`),
  KEY `FK_Notificaciones_Evento` (`IdEvento`),
  KEY `FK_Notificaciones_Usuario` (`IdUsuario`),
  CONSTRAINT `FK_Notificaciones_Evento` FOREIGN KEY (`IdEvento`) REFERENCES `evento` (`IdEvento`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `FK_Notificaciones_Usuario` FOREIGN KEY (`IdUsuario`) REFERENCES `usuario` (`IdUsuario`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=332 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notificaciones`
--

LOCK TABLES `notificaciones` WRITE;
/*!40000 ALTER TABLE `notificaciones` DISABLE KEYS */;
/*!40000 ALTER TABLE `notificaciones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `perfilinstructor`
--

DROP TABLE IF EXISTS `perfilinstructor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `perfilinstructor` (
  `id` int NOT NULL AUTO_INCREMENT,
  `UsuarioId` int NOT NULL,
  `profesion` varchar(100) DEFAULT NULL,
  `ubicacion` varchar(150) DEFAULT NULL,
  `imagen` text,
  `imagenubicacion` text,
  PRIMARY KEY (`id`),
  KEY `FK_PerfilInstructor_Usuario` (`UsuarioId`),
  CONSTRAINT `FK_PerfilInstructor_Usuario` FOREIGN KEY (`UsuarioId`) REFERENCES `usuario` (`IdUsuario`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `perfilinstructor`
--

LOCK TABLES `perfilinstructor` WRITE;
/*!40000 ALTER TABLE `perfilinstructor` DISABLE KEYS */;
/*!40000 ALTER TABLE `perfilinstructor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `planificacionevento`
--

DROP TABLE IF EXISTS `planificacionevento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `planificacionevento` (
  `IdPlanificarE` int NOT NULL AUTO_INCREMENT,
  `NombreEvento` varchar(150) NOT NULL,
  `FechaEvento` datetime NOT NULL,
  `LugarDeEvento` varchar(50) NOT NULL,
  `Recursos` text,
  `IdGestionE` int NOT NULL,
  `IdUsuario` int NOT NULL,
  `createdAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `TipoEvento` varchar(100) DEFAULT NULL,
  `ImagenEvento` varchar(255) DEFAULT NULL,
  `Trimestre` varchar(10) DEFAULT NULL,
  `EstadoCarga` enum('Manual','Masivo') NOT NULL DEFAULT 'Manual',
  PRIMARY KEY (`IdPlanificarE`),
  KEY `FK_PlanificacionEvento_Gestion` (`IdGestionE`),
  KEY `fk_planificacion_usuario` (`IdUsuario`),
  CONSTRAINT `fk_planificacion_usuario` FOREIGN KEY (`IdUsuario`) REFERENCES `usuario` (`IdUsuario`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `FK_PlanificacionEvento_Gestion` FOREIGN KEY (`IdGestionE`) REFERENCES `gestionevento` (`IdGestionE`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `planificacionevento`
--

LOCK TABLES `planificacionevento` WRITE;
/*!40000 ALTER TABLE `planificacionevento` DISABLE KEYS */;
/*!40000 ALTER TABLE `planificacionevento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `prestamoelementos`
--

DROP TABLE IF EXISTS `prestamoelementos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prestamoelementos` (
  `IdAlquiler` int NOT NULL AUTO_INCREMENT,
  `CantidadDisponible` int DEFAULT '1',
  `NombreElemento` varchar(50) NOT NULL,
  `FechaSolicitud` datetime NOT NULL,
  `FechaDevolucion` datetime NOT NULL,
  `RegistradoPor` varchar(50) NOT NULL,
  `Observaciones` text,
  `Imagen` varchar(255) DEFAULT NULL,
  `CumplioConEntrega` tinyint(1) DEFAULT '0',
  `IdUsuario` int DEFAULT NULL,
  `IdElemento` int DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`IdAlquiler`),
  KEY `FK_PrestamoElementos_Usuario` (`IdUsuario`),
  KEY `FK_PrestamoElementos_Elemento` (`IdElemento`),
  CONSTRAINT `FK_PrestamoElementos_Elemento` FOREIGN KEY (`IdElemento`) REFERENCES `elemento` (`IdElemento`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `FK_PrestamoElementos_Usuario` FOREIGN KEY (`IdUsuario`) REFERENCES `usuario` (`IdUsuario`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prestamoelementos`
--

LOCK TABLES `prestamoelementos` WRITE;
/*!40000 ALTER TABLE `prestamoelementos` DISABLE KEYS */;
/*!40000 ALTER TABLE `prestamoelementos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reaccionevento`
--

DROP TABLE IF EXISTS `reaccionevento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reaccionevento` (
  `IdReaccion` int NOT NULL AUTO_INCREMENT,
  `IdUsuario` int NOT NULL,
  `IdEvento` int NOT NULL,
  `Tipo` enum('like','dislike') NOT NULL,
  `FechaReaccion` datetime DEFAULT CURRENT_TIMESTAMP,
  `createdAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`IdReaccion`),
  UNIQUE KEY `IdUsuario` (`IdUsuario`,`IdEvento`),
  KEY `IdEvento` (`IdEvento`),
  CONSTRAINT `reaccionevento_ibfk_1` FOREIGN KEY (`IdUsuario`) REFERENCES `usuario` (`IdUsuario`),
  CONSTRAINT `reaccionevento_ibfk_2` FOREIGN KEY (`IdEvento`) REFERENCES `evento` (`IdEvento`)
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reaccionevento`
--

LOCK TABLES `reaccionevento` WRITE;
/*!40000 ALTER TABLE `reaccionevento` DISABLE KEYS */;
/*!40000 ALTER TABLE `reaccionevento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `relusuarioevento`
--

DROP TABLE IF EXISTS `relusuarioevento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `relusuarioevento` (
  `IdUsuario` int NOT NULL,
  `IdEvento` int NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `ConfirmoAsistencia` tinyint(1) DEFAULT '0',
  `Asistio` tinyint(1) DEFAULT '0',
  `Penalizacion` int DEFAULT '0',
  PRIMARY KEY (`IdUsuario`,`IdEvento`),
  KEY `FK_RelUsuarioEvento_Evento` (`IdEvento`),
  CONSTRAINT `FK_RelUsuarioEvento_Evento` FOREIGN KEY (`IdEvento`) REFERENCES `evento` (`IdEvento`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_RelUsuarioEvento_Usuario` FOREIGN KEY (`IdUsuario`) REFERENCES `usuario` (`IdUsuario`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `relusuarioevento`
--

LOCK TABLES `relusuarioevento` WRITE;
/*!40000 ALTER TABLE `relusuarioevento` DISABLE KEYS */;
/*!40000 ALTER TABLE `relusuarioevento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `relusuariofeedback`
--

DROP TABLE IF EXISTS `relusuariofeedback`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `relusuariofeedback` (
  `IdUsuario` int NOT NULL,
  `IdFeedback` int NOT NULL,
  `FechaRelUsuaFeed` date DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`IdUsuario`,`IdFeedback`),
  KEY `FK_RelUsuarioFeedback_Feedback` (`IdFeedback`),
  CONSTRAINT `FK_RelUsuarioFeedback_Feedback` FOREIGN KEY (`IdFeedback`) REFERENCES `feedback` (`IdFeedback`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_RelUsuarioFeedback_Usuario` FOREIGN KEY (`IdUsuario`) REFERENCES `usuario` (`IdUsuario`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `relusuariofeedback`
--

LOCK TABLES `relusuariofeedback` WRITE;
/*!40000 ALTER TABLE `relusuariofeedback` DISABLE KEYS */;
/*!40000 ALTER TABLE `relusuariofeedback` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `resumeneventoia`
--

DROP TABLE IF EXISTS `resumeneventoia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `resumeneventoia` (
  `id` int NOT NULL AUTO_INCREMENT,
  `IdActividad` int NOT NULL,
  `IdEvento` int NOT NULL,
  `totalInscritos` int DEFAULT NULL,
  `totalAsistentes` int DEFAULT NULL,
  `porcentajeParticipacion` float DEFAULT NULL,
  `fichaMayorParticipacion` varchar(255) DEFAULT NULL,
  `jornadaDestacada` varchar(255) DEFAULT NULL,
  `resumenIA` text,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_ResumenEventoIA_Actividad` (`IdActividad`),
  KEY `FK_ResumenEventoIA_Evento` (`IdEvento`),
  CONSTRAINT `FK_ResumenEventoIA_Actividad` FOREIGN KEY (`IdActividad`) REFERENCES `actividad` (`IdActividad`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_ResumenEventoIA_Evento` FOREIGN KEY (`IdEvento`) REFERENCES `evento` (`IdEvento`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `resumeneventoia`
--

LOCK TABLES `resumeneventoia` WRITE;
/*!40000 ALTER TABLE `resumeneventoia` DISABLE KEYS */;
/*!40000 ALTER TABLE `resumeneventoia` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rolusuario`
--

DROP TABLE IF EXISTS `rolusuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rolusuario` (
  `IdRol` int NOT NULL AUTO_INCREMENT,
  `NombreRol` enum('Administrador','Aprendiz','Instructor') NOT NULL,
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`IdRol`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rolusuario`
--

LOCK TABLES `rolusuario` WRITE;
/*!40000 ALTER TABLE `rolusuario` DISABLE KEYS */;
/*!40000 ALTER TABLE `rolusuario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `solicitudapoyo`
--

DROP TABLE IF EXISTS `solicitudapoyo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `solicitudapoyo` (
  `IdSolicitud` int NOT NULL AUTO_INCREMENT,
  `Descripcion` text NOT NULL,
  `ContactoEmergencia` varchar(100) DEFAULT NULL,
  `TipoAyuda` enum('Psicologica','Emocional','Economica','Otra') NOT NULL,
  `Estado` enum('Pendiente','En Proceso','Atendido','Finalizado') DEFAULT NULL,
  `IdUsuario` int NOT NULL,
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`IdSolicitud`),
  KEY `FK_SolicitudApoyo_Usuario` (`IdUsuario`),
  CONSTRAINT `FK_SolicitudApoyo_Usuario` FOREIGN KEY (`IdUsuario`) REFERENCES `usuario` (`IdUsuario`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `solicitudapoyo`
--

LOCK TABLES `solicitudapoyo` WRITE;
/*!40000 ALTER TABLE `solicitudapoyo` DISABLE KEYS */;
/*!40000 ALTER TABLE `solicitudapoyo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuario`
--

DROP TABLE IF EXISTS `usuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuario` (
  `IdUsuario` int NOT NULL AUTO_INCREMENT,
  `IdRol` int NOT NULL,
  `IdentificacionUsuario` varchar(50) NOT NULL,
  `Nombre` varchar(100) NOT NULL,
  `Apellido` varchar(100) NOT NULL,
  `Correo` varchar(255) NOT NULL,
  `Telefono` varchar(20) NOT NULL,
  `Contrasena` varchar(255) NOT NULL,
  `FechaRegistro` date NOT NULL,
  `token` varchar(6) DEFAULT NULL,
  `confirmed` tinyint(1) DEFAULT '0',
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `FotoPerfil` text,
  PRIMARY KEY (`IdUsuario`),
  KEY `FK_Usuario_RolUsuario` (`IdRol`),
  CONSTRAINT `FK_Usuario_RolUsuario` FOREIGN KEY (`IdRol`) REFERENCES `rolusuario` (`IdRol`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuario`
--

LOCK TABLES `usuario` WRITE;
/*!40000 ALTER TABLE `usuario` DISABLE KEYS */;
/*!40000 ALTER TABLE `usuario` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-07-31  9:06:41
