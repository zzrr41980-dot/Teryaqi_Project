-- phpMyAdmin SQL Dump
-- version 6.0.0-dev+20260412.9edf12e957
-- https://www.phpmyadmin.net/
--
-- مضيف: 192.168.30.23
-- وقت الجيل: 12 Apr 2026 الساعة 18:12
-- إصدار الخادم: 8.0.18
-- نسخة PHP: 8.2.26

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- قاعدة بيانات: `smart_medicine`
--

-- --------------------------------------------------------

--
-- بنية الجدول `CHRONIC_DISEASES`
--

CREATE TABLE `CHRONIC_DISEASES` (
  `disease_id` int(11) NOT NULL,
  `disease_name` varchar(100) NOT NULL,
  `description` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- بنية الجدول `DISEASES`
--

CREATE TABLE `DISEASES` (
  `id` int(11) NOT NULL,
  `patient_id` int(11) DEFAULT NULL,
  `disease_id` int(11) DEFAULT NULL,
  `diagnosed_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- بنية الجدول `MEDICATIONS`
--

CREATE TABLE `MEDICATIONS` (
  `medication_id` int(11) NOT NULL,
  `patient_id` int(11) DEFAULT NULL,
  `medication_name` varchar(100) NOT NULL,
  `dosage_form` enum('Tablet','Capsule','Syrup') NOT NULL,
  `dosage_amount` varchar(50) DEFAULT NULL,
  `intake_time` time DEFAULT NULL,
  `instructions` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- بنية الجدول `NOTIFICATIONS`
--

CREATE TABLE `NOTIFICATIONS` (
  `notification_id` int(11) NOT NULL,
  `patient_id` int(11) DEFAULT NULL,
  `message` text,
  `sent_time` datetime DEFAULT NULL,
  `status` enum('Sent','Read','Ignored') DEFAULT 'Sent'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- بنية الجدول `PATIENTS`
--

CREATE TABLE `PATIENTS` (
  `patient_id` int(11) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `national_id` varchar(20) NOT NULL,
  `date_of_birth` date DEFAULT NULL,
  `gender` enum('Male','Female') NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `pill_box_serial` varchar(100) DEFAULT NULL,
  `pill_box_status` enum('Active','Inactive') DEFAULT 'Active',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- بنية الجدول `SENSOR_LOGS`
--

CREATE TABLE `SENSOR_LOGS` (
  `log_id` int(11) NOT NULL,
  `patient_id` int(11) DEFAULT NULL,
  `medication_name` varchar(100) DEFAULT NULL,
  `taken_status` enum('Taken','Missed') NOT NULL,
  `taken_time` time DEFAULT NULL,
  `log_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Indexes for dumped tables
--

--
-- فهارس للجدول `CHRONIC_DISEASES`
--
ALTER TABLE `CHRONIC_DISEASES`
  ADD PRIMARY KEY (`disease_id`);

--
-- فهارس للجدول `DISEASES`
--
ALTER TABLE `DISEASES`
  ADD PRIMARY KEY (`id`),
  ADD KEY `patient_id` (`patient_id`),
  ADD KEY `disease_id` (`disease_id`);

--
-- فهارس للجدول `MEDICATIONS`
--
ALTER TABLE `MEDICATIONS`
  ADD PRIMARY KEY (`medication_id`),
  ADD KEY `patient_id` (`patient_id`);

--
-- فهارس للجدول `NOTIFICATIONS`
--
ALTER TABLE `NOTIFICATIONS`
  ADD PRIMARY KEY (`notification_id`),
  ADD KEY `patient_id` (`patient_id`);

--
-- فهارس للجدول `PATIENTS`
--
ALTER TABLE `PATIENTS`
  ADD PRIMARY KEY (`patient_id`),
  ADD UNIQUE KEY `national_id` (`national_id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `pill_box_serial` (`pill_box_serial`);

--
-- فهارس للجدول `SENSOR_LOGS`
--
ALTER TABLE `SENSOR_LOGS`
  ADD PRIMARY KEY (`log_id`),
  ADD KEY `patient_id` (`patient_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `CHRONIC_DISEASES`
--
ALTER TABLE `CHRONIC_DISEASES`
  MODIFY `disease_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `DISEASES`
--
ALTER TABLE `DISEASES`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `MEDICATIONS`
--
ALTER TABLE `MEDICATIONS`
  MODIFY `medication_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `NOTIFICATIONS`
--
ALTER TABLE `NOTIFICATIONS`
  MODIFY `notification_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `PATIENTS`
--
ALTER TABLE `PATIENTS`
  MODIFY `patient_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `SENSOR_LOGS`
--
ALTER TABLE `SENSOR_LOGS`
  MODIFY `log_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- القيود المفروضة على الجداول الملقاة
--

--
-- قيود الجداول `DISEASES`
--
ALTER TABLE `DISEASES`
  ADD CONSTRAINT `DISEASES_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `PATIENTS` (`patient_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `DISEASES_ibfk_2` FOREIGN KEY (`disease_id`) REFERENCES `CHRONIC_DISEASES` (`disease_id`) ON DELETE CASCADE;

--
-- قيود الجداول `MEDICATIONS`
--
ALTER TABLE `MEDICATIONS`
  ADD CONSTRAINT `MEDICATIONS_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `PATIENTS` (`patient_id`) ON DELETE CASCADE;

--
-- قيود الجداول `NOTIFICATIONS`
--
ALTER TABLE `NOTIFICATIONS`
  ADD CONSTRAINT `NOTIFICATIONS_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `PATIENTS` (`patient_id`) ON DELETE CASCADE;

--
-- قيود الجداول `SENSOR_LOGS`
--
ALTER TABLE `SENSOR_LOGS`
  ADD CONSTRAINT `SENSOR_LOGS_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `PATIENTS` (`patient_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
