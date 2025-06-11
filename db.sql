-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1:3306
-- Tiempo de generación: 10-06-2025 a las 14:43:28
-- Versión del servidor: 10.11.10-MariaDB-log
-- Versión de PHP: 7.2.34

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `u936058592_jyHch`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `admin_roles`
--

CREATE TABLE `admin_roles` (
  `idrol` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `admin_sessions`
--

CREATE TABLE `admin_sessions` (
  `idsession` char(64) NOT NULL,
  `iduser` int(11) NOT NULL,
  `user_agent` varchar(255) DEFAULT NULL,
  `ip` varchar(45) DEFAULT NULL,
  `vence` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `admin_users`
--

CREATE TABLE `admin_users` (
  `iduser` int(11) NOT NULL,
  `nombre` varchar(120) NOT NULL,
  `email` varchar(120) NOT NULL,
  `telefono` varchar(30) NOT NULL,
  `pass` varchar(255) NOT NULL,
  `idrol` int(11) NOT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `genero` varchar(20) DEFAULT NULL,
  `ciudad_origen` varchar(100) DEFAULT NULL,
  `rango_edad` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `agenda_config`
--

CREATE TABLE `agenda_config` (
  `idconf` int(11) NOT NULL,
  `idprof` int(11) NOT NULL,
  `dia_sem` tinyint(1) NOT NULL,
  `hora_ini` time NOT NULL,
  `hora_fin` time NOT NULL,
  `duracion` int(11) NOT NULL DEFAULT 20
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `asientos`
--

CREATE TABLE `asientos` (
  `idasiento` int(11) NOT NULL,
  `idpalco` int(11) NOT NULL,
  `numero_asiento` tinyint(4) NOT NULL,
  `estado` enum('libre','reservado','vendido') DEFAULT 'libre'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `background_images`
--

CREATE TABLE `background_images` (
  `id` int(11) NOT NULL,
  `image_url` varchar(255) NOT NULL,
  `alt_text` varchar(255) DEFAULT NULL,
  `order_position` int(11) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `blog_articulos`
--

CREATE TABLE `blog_articulos` (
  `idart` int(11) NOT NULL,
  `idcat` int(11) NOT NULL,
  `titulo` varchar(200) NOT NULL,
  `slug` varchar(200) NOT NULL,
  `resumen` text NOT NULL,
  `contenido` longtext NOT NULL,
  `imagen` varchar(200) DEFAULT NULL,
  `fecha_pub` datetime NOT NULL DEFAULT current_timestamp(),
  `autor` varchar(120) DEFAULT 'Admin'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `blog_categorias`
--

CREATE TABLE `blog_categorias` (
  `idcat` int(11) NOT NULL,
  `nombre` varchar(120) NOT NULL,
  `slug` varchar(120) NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `citas`
--

CREATE TABLE `citas` (
  `idcita` int(11) NOT NULL,
  `idprof` int(11) NOT NULL,
  `fecha` date NOT NULL,
  `hora` time NOT NULL,
  `paciente` varchar(120) NOT NULL,
  `motivo` varchar(200) DEFAULT NULL,
  `estado` enum('pendiente','confirmada','cancelada','atendida') DEFAULT 'pendiente',
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `contact_info`
--

CREATE TABLE `contact_info` (
  `idinfo` int(11) NOT NULL,
  `icono` varchar(50) NOT NULL,
  `titulo` varchar(100) NOT NULL,
  `detalle` varchar(200) NOT NULL,
  `orden` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `contact_mensajes`
--

CREATE TABLE `contact_mensajes` (
  `idmsg` int(11) NOT NULL,
  `nombre` varchar(120) NOT NULL,
  `telefono` varchar(60) DEFAULT NULL,
  `email` varchar(120) NOT NULL,
  `idmotivo` int(11) DEFAULT NULL,
  `mensaje` text NOT NULL,
  `acepta` tinyint(1) NOT NULL DEFAULT 0,
  `fecha_env` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `contact_motivos`
--

CREATE TABLE `contact_motivos` (
  `idmotivo` int(11) NOT NULL,
  `motivo` varchar(120) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detservicio`
--

CREATE TABLE `detservicio` (
  `idet` int(11) NOT NULL,
  `tituloserv` varchar(200) NOT NULL,
  `descripcion` text NOT NULL,
  `image` varchar(200) NOT NULL,
  `idser` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `dias_semana`
--

CREATE TABLE `dias_semana` (
  `iddia` tinyint(1) NOT NULL,
  `nombre` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `especialidades`
--

CREATE TABLE `especialidades` (
  `idesp` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `slug` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `filas`
--

CREATE TABLE `filas` (
  `idfila` int(11) NOT NULL,
  `idprof` int(11) NOT NULL,
  `numero_fila` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `galeria_categorias`
--

CREATE TABLE `galeria_categorias` (
  `idcat` int(11) NOT NULL,
  `nombre` varchar(120) NOT NULL,
  `slug` varchar(120) NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `orden` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `galeria_imagenes`
--

CREATE TABLE `galeria_imagenes` (
  `idimg` int(11) NOT NULL,
  `idcat` int(11) NOT NULL,
  `archivo` varchar(200) NOT NULL,
  `alt` varchar(150) DEFAULT '',
  `orden` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `menu_items`
--

CREATE TABLE `menu_items` (
  `id` int(11) NOT NULL,
  `label` varchar(100) NOT NULL,
  `url` varchar(255) DEFAULT NULL,
  `order_position` int(11) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `miembros`
--

CREATE TABLE `miembros` (
  `id` int(11) NOT NULL,
  `nombre` varchar(255) NOT NULL,
  `cargo` varchar(255) NOT NULL,
  `imagen` varchar(255) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pacientes`
--

CREATE TABLE `pacientes` (
  `idpaciente` int(11) NOT NULL,
  `documento` varchar(20) NOT NULL,
  `nombre` varchar(120) NOT NULL,
  `telefono` varchar(20) NOT NULL,
  `correo` varchar(120) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `palcos`
--

CREATE TABLE `palcos` (
  `idpalco` int(11) NOT NULL,
  `idfila` int(11) NOT NULL,
  `numero_palco` int(11) NOT NULL,
  `precio` decimal(10,2) NOT NULL DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `precios`
--

CREATE TABLE `precios` (
  `id_p` int(10) UNSIGNED NOT NULL,
  `idprof` int(11) NOT NULL,
  `precio` decimal(10,2) NOT NULL,
  `descuento` decimal(10,2) NOT NULL DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `profesionales`
--

CREATE TABLE `profesionales` (
  `idprof` int(11) NOT NULL,
  `nombre` varchar(120) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `email` varchar(120) DEFAULT NULL,
  `telefono` varchar(40) DEFAULT NULL,
  `descripcion` varchar(255) NOT NULL,
  `id_servicio` int(11) NOT NULL,
  `foto` varchar(200) DEFAULT NULL,
  `is_activo` tinyint(1) DEFAULT 1,
  `idesp` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `reservas_palco`
--

CREATE TABLE `reservas_palco` (
  `idreserva` int(11) NOT NULL,
  `idpalco` int(11) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  `nombre` varchar(120) NOT NULL,
  `celular` varchar(40) NOT NULL,
  `ciudad` varchar(120) NOT NULL,
  `fecha_hora` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `services`
--

CREATE TABLE `services` (
  `id` int(11) NOT NULL,
  `title` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `image_path` varchar(255) DEFAULT NULL,
  `btn_text` varchar(100) DEFAULT NULL,
  `btn_link` varchar(255) DEFAULT NULL,
  `order_position` int(11) DEFAULT 1,
  `icons` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `servicios`
--

CREATE TABLE `servicios` (
  `idser` int(11) NOT NULL,
  `titulo` varchar(200) NOT NULL,
  `slug` varchar(200) NOT NULL,
  `subtitulo` varchar(200) NOT NULL,
  `descripcion` text NOT NULL,
  `image` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `slides`
--

CREATE TABLE `slides` (
  `id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `image_path` varchar(255) DEFAULT NULL,
  `button_text` varchar(100) DEFAULT NULL,
  `button_link` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_categorias`
--

CREATE TABLE `tbl_categorias` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_clases`
--

CREATE TABLE `tbl_clases` (
  `id` int(11) NOT NULL,
  `nombre` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `slug` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `descripcion` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `id_servicio` int(11) NOT NULL,
  `imagen` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_disponibilidad_clases`
--

CREATE TABLE `tbl_disponibilidad_clases` (
  `id` int(11) NOT NULL,
  `id_clase` int(11) NOT NULL,
  `fecha` date NOT NULL,
  `hora` time NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_paquetes`
--

CREATE TABLE `tbl_paquetes` (
  `id` int(11) NOT NULL,
  `nombre` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `slug` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `descripcion` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `clases` int(11) NOT NULL,
  `vigencia` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `modalidad` int(11) NOT NULL,
  `precio` int(11) NOT NULL,
  `imagen` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_productos`
--

CREATE TABLE `tbl_productos` (
  `id` int(11) NOT NULL,
  `nombre` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `descripcion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `categoria_id` int(11) DEFAULT NULL,
  `precio` decimal(10,2) NOT NULL,
  `imagen` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_proteinas`
--

CREATE TABLE `tbl_proteinas` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_tipocls`
--

CREATE TABLE `tbl_tipocls` (
  `id` int(11) NOT NULL,
  `servicio` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `categoria` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1: Clase, 2: Paquete'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `testimonials`
--

CREATE TABLE `testimonials` (
  `id` int(11) NOT NULL,
  `customer_name` varchar(100) NOT NULL,
  `testimonial_text` text NOT NULL,
  `rating` tinyint(1) DEFAULT 5,
  `avatar_path` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `order_position` int(11) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tickets`
--

CREATE TABLE `tickets` (
  `id` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `id_evento` int(11) NOT NULL,
  `codigo_qr` varchar(255) NOT NULL,
  `generado_en` datetime DEFAULT current_timestamp(),
  `asistencia` tinyint(1) NOT NULL DEFAULT 0,
  `asistenciaConfirmada` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tickets_palco`
--

CREATE TABLE `tickets_palco` (
  `idticket` int(11) NOT NULL,
  `idreserva` int(11) NOT NULL,
  `numero_asiento` tinyint(4) NOT NULL,
  `nombre` varchar(120) NOT NULL,
  `celular` varchar(40) NOT NULL,
  `genero` enum('M','F','X') NOT NULL,
  `ciudad` varchar(120) NOT NULL,
  `codigo_qr` varchar(64) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vigencias`
--

CREATE TABLE `vigencias` (
  `idvig` int(11) NOT NULL,
  `idprof` int(11) NOT NULL,
  `num_clases` int(10) UNSIGNED NOT NULL,
  `dias_vigencia` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `admin_roles`
--
ALTER TABLE `admin_roles`
  ADD PRIMARY KEY (`idrol`),
  ADD UNIQUE KEY `nombre` (`nombre`);

--
-- Indices de la tabla `admin_sessions`
--
ALTER TABLE `admin_sessions`
  ADD PRIMARY KEY (`idsession`),
  ADD KEY `iduser` (`iduser`);

--
-- Indices de la tabla `admin_users`
--
ALTER TABLE `admin_users`
  ADD PRIMARY KEY (`iduser`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `idrol` (`idrol`);

--
-- Indices de la tabla `agenda_config`
--
ALTER TABLE `agenda_config`
  ADD PRIMARY KEY (`idconf`),
  ADD UNIQUE KEY `idprof` (`idprof`,`dia_sem`,`hora_ini`),
  ADD KEY `fk_dia_sem` (`dia_sem`);

--
-- Indices de la tabla `asientos`
--
ALTER TABLE `asientos`
  ADD PRIMARY KEY (`idasiento`),
  ADD UNIQUE KEY `idpalco` (`idpalco`,`numero_asiento`);

--
-- Indices de la tabla `background_images`
--
ALTER TABLE `background_images`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `blog_articulos`
--
ALTER TABLE `blog_articulos`
  ADD PRIMARY KEY (`idart`),
  ADD UNIQUE KEY `slug` (`slug`),
  ADD KEY `idcat` (`idcat`);

--
-- Indices de la tabla `blog_categorias`
--
ALTER TABLE `blog_categorias`
  ADD PRIMARY KEY (`idcat`),
  ADD UNIQUE KEY `slug` (`slug`);

--
-- Indices de la tabla `citas`
--
ALTER TABLE `citas`
  ADD PRIMARY KEY (`idcita`),
  ADD UNIQUE KEY `idprof` (`idprof`,`fecha`,`hora`);

--
-- Indices de la tabla `contact_info`
--
ALTER TABLE `contact_info`
  ADD PRIMARY KEY (`idinfo`);

--
-- Indices de la tabla `contact_mensajes`
--
ALTER TABLE `contact_mensajes`
  ADD PRIMARY KEY (`idmsg`),
  ADD KEY `idmotivo` (`idmotivo`);

--
-- Indices de la tabla `contact_motivos`
--
ALTER TABLE `contact_motivos`
  ADD PRIMARY KEY (`idmotivo`);

--
-- Indices de la tabla `detservicio`
--
ALTER TABLE `detservicio`
  ADD PRIMARY KEY (`idet`);

--
-- Indices de la tabla `dias_semana`
--
ALTER TABLE `dias_semana`
  ADD PRIMARY KEY (`iddia`);

--
-- Indices de la tabla `especialidades`
--
ALTER TABLE `especialidades`
  ADD PRIMARY KEY (`idesp`),
  ADD UNIQUE KEY `slug` (`slug`);

--
-- Indices de la tabla `filas`
--
ALTER TABLE `filas`
  ADD PRIMARY KEY (`idfila`),
  ADD UNIQUE KEY `idprof` (`idprof`,`numero_fila`);

--
-- Indices de la tabla `galeria_categorias`
--
ALTER TABLE `galeria_categorias`
  ADD PRIMARY KEY (`idcat`),
  ADD UNIQUE KEY `slug` (`slug`);

--
-- Indices de la tabla `galeria_imagenes`
--
ALTER TABLE `galeria_imagenes`
  ADD PRIMARY KEY (`idimg`),
  ADD KEY `idcat` (`idcat`);

--
-- Indices de la tabla `menu_items`
--
ALTER TABLE `menu_items`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `miembros`
--
ALTER TABLE `miembros`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `pacientes`
--
ALTER TABLE `pacientes`
  ADD PRIMARY KEY (`idpaciente`),
  ADD UNIQUE KEY `documento` (`documento`);

--
-- Indices de la tabla `palcos`
--
ALTER TABLE `palcos`
  ADD PRIMARY KEY (`idpalco`),
  ADD UNIQUE KEY `idfila` (`idfila`,`numero_palco`);

--
-- Indices de la tabla `precios`
--
ALTER TABLE `precios`
  ADD PRIMARY KEY (`id_p`),
  ADD UNIQUE KEY `unq_precio_prof` (`idprof`);

--
-- Indices de la tabla `profesionales`
--
ALTER TABLE `profesionales`
  ADD PRIMARY KEY (`idprof`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `fk_prof_esp` (`idesp`);

--
-- Indices de la tabla `reservas_palco`
--
ALTER TABLE `reservas_palco`
  ADD PRIMARY KEY (`idreserva`);

--
-- Indices de la tabla `services`
--
ALTER TABLE `services`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `servicios`
--
ALTER TABLE `servicios`
  ADD PRIMARY KEY (`idser`);

--
-- Indices de la tabla `slides`
--
ALTER TABLE `slides`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `tbl_categorias`
--
ALTER TABLE `tbl_categorias`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `tbl_clases`
--
ALTER TABLE `tbl_clases`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `tbl_disponibilidad_clases`
--
ALTER TABLE `tbl_disponibilidad_clases`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `tbl_paquetes`
--
ALTER TABLE `tbl_paquetes`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `tbl_productos`
--
ALTER TABLE `tbl_productos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `categoria_id` (`categoria_id`);

--
-- Indices de la tabla `tbl_proteinas`
--
ALTER TABLE `tbl_proteinas`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `tbl_tipocls`
--
ALTER TABLE `tbl_tipocls`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `testimonials`
--
ALTER TABLE `testimonials`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `tickets`
--
ALTER TABLE `tickets`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_usuario` (`id_usuario`),
  ADD KEY `id_evento` (`id_evento`);

--
-- Indices de la tabla `tickets_palco`
--
ALTER TABLE `tickets_palco`
  ADD PRIMARY KEY (`idticket`);

--
-- Indices de la tabla `vigencias`
--
ALTER TABLE `vigencias`
  ADD PRIMARY KEY (`idvig`),
  ADD UNIQUE KEY `unq_vigencia_prof` (`idprof`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `admin_roles`
--
ALTER TABLE `admin_roles`
  MODIFY `idrol` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `admin_users`
--
ALTER TABLE `admin_users`
  MODIFY `iduser` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `agenda_config`
--
ALTER TABLE `agenda_config`
  MODIFY `idconf` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `asientos`
--
ALTER TABLE `asientos`
  MODIFY `idasiento` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `background_images`
--
ALTER TABLE `background_images`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `blog_articulos`
--
ALTER TABLE `blog_articulos`
  MODIFY `idart` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `blog_categorias`
--
ALTER TABLE `blog_categorias`
  MODIFY `idcat` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `citas`
--
ALTER TABLE `citas`
  MODIFY `idcita` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `contact_info`
--
ALTER TABLE `contact_info`
  MODIFY `idinfo` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `contact_mensajes`
--
ALTER TABLE `contact_mensajes`
  MODIFY `idmsg` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `contact_motivos`
--
ALTER TABLE `contact_motivos`
  MODIFY `idmotivo` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `detservicio`
--
ALTER TABLE `detservicio`
  MODIFY `idet` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `especialidades`
--
ALTER TABLE `especialidades`
  MODIFY `idesp` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `filas`
--
ALTER TABLE `filas`
  MODIFY `idfila` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `galeria_categorias`
--
ALTER TABLE `galeria_categorias`
  MODIFY `idcat` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `galeria_imagenes`
--
ALTER TABLE `galeria_imagenes`
  MODIFY `idimg` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `menu_items`
--
ALTER TABLE `menu_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `miembros`
--
ALTER TABLE `miembros`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `pacientes`
--
ALTER TABLE `pacientes`
  MODIFY `idpaciente` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `palcos`
--
ALTER TABLE `palcos`
  MODIFY `idpalco` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `precios`
--
ALTER TABLE `precios`
  MODIFY `id_p` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `profesionales`
--
ALTER TABLE `profesionales`
  MODIFY `idprof` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `reservas_palco`
--
ALTER TABLE `reservas_palco`
  MODIFY `idreserva` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `services`
--
ALTER TABLE `services`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `servicios`
--
ALTER TABLE `servicios`
  MODIFY `idser` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `slides`
--
ALTER TABLE `slides`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tbl_categorias`
--
ALTER TABLE `tbl_categorias`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tbl_clases`
--
ALTER TABLE `tbl_clases`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tbl_disponibilidad_clases`
--
ALTER TABLE `tbl_disponibilidad_clases`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tbl_paquetes`
--
ALTER TABLE `tbl_paquetes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tbl_productos`
--
ALTER TABLE `tbl_productos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tbl_proteinas`
--
ALTER TABLE `tbl_proteinas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tbl_tipocls`
--
ALTER TABLE `tbl_tipocls`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `testimonials`
--
ALTER TABLE `testimonials`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tickets`
--
ALTER TABLE `tickets`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tickets_palco`
--
ALTER TABLE `tickets_palco`
  MODIFY `idticket` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `vigencias`
--
ALTER TABLE `vigencias`
  MODIFY `idvig` int(11) NOT NULL AUTO_INCREMENT;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `admin_sessions`
--
ALTER TABLE `admin_sessions`
  ADD CONSTRAINT `admin_sessions_ibfk_1` FOREIGN KEY (`iduser`) REFERENCES `admin_users` (`iduser`);

--
-- Filtros para la tabla `admin_users`
--
ALTER TABLE `admin_users`
  ADD CONSTRAINT `admin_users_ibfk_1` FOREIGN KEY (`idrol`) REFERENCES `admin_roles` (`idrol`);

--
-- Filtros para la tabla `agenda_config`
--
ALTER TABLE `agenda_config`
  ADD CONSTRAINT `agenda_config_ibfk_1` FOREIGN KEY (`idprof`) REFERENCES `profesionales` (`idprof`),
  ADD CONSTRAINT `fk_dia_sem` FOREIGN KEY (`dia_sem`) REFERENCES `dias_semana` (`iddia`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `blog_articulos`
--
ALTER TABLE `blog_articulos`
  ADD CONSTRAINT `blog_articulos_ibfk_1` FOREIGN KEY (`idcat`) REFERENCES `blog_categorias` (`idcat`);

--
-- Filtros para la tabla `citas`
--
ALTER TABLE `citas`
  ADD CONSTRAINT `citas_ibfk_1` FOREIGN KEY (`idprof`) REFERENCES `profesionales` (`idprof`);

--
-- Filtros para la tabla `contact_mensajes`
--
ALTER TABLE `contact_mensajes`
  ADD CONSTRAINT `contact_mensajes_ibfk_1` FOREIGN KEY (`idmotivo`) REFERENCES `contact_motivos` (`idmotivo`);

--
-- Filtros para la tabla `galeria_imagenes`
--
ALTER TABLE `galeria_imagenes`
  ADD CONSTRAINT `galeria_imagenes_ibfk_1` FOREIGN KEY (`idcat`) REFERENCES `galeria_categorias` (`idcat`);

--
-- Filtros para la tabla `precios`
--
ALTER TABLE `precios`
  ADD CONSTRAINT `fk_precio_prof` FOREIGN KEY (`idprof`) REFERENCES `profesionales` (`idprof`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `profesionales`
--
ALTER TABLE `profesionales`
  ADD CONSTRAINT `fk_prof_esp` FOREIGN KEY (`idesp`) REFERENCES `especialidades` (`idesp`);

--
-- Filtros para la tabla `tbl_productos`
--
ALTER TABLE `tbl_productos`
  ADD CONSTRAINT `tbl_productos_ibfk_1` FOREIGN KEY (`categoria_id`) REFERENCES `tbl_categorias` (`id`);

--
-- Filtros para la tabla `tickets`
--
ALTER TABLE `tickets`
  ADD CONSTRAINT `tickets_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `admin_users` (`iduser`),
  ADD CONSTRAINT `tickets_ibfk_2` FOREIGN KEY (`id_evento`) REFERENCES `detservicio` (`idet`);

--
-- Filtros para la tabla `vigencias`
--
ALTER TABLE `vigencias`
  ADD CONSTRAINT `fk_vigencia_prof` FOREIGN KEY (`idprof`) REFERENCES `profesionales` (`idprof`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
