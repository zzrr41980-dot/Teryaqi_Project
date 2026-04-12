-- phpMyAdmin SQL Dump
-- version 6.0.0-dev+20260412.9edf12e957
-- https://www.phpmyadmin.net/
--
-- مضيف: 192.168.30.23
-- وقت الجيل: 12 Apr 2026 الساعة 18:08
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

--
-- Indexes for dumped tables
--

--
-- فهارس للجدول `PATIENTS`
--
ALTER TABLE `PATIENTS`
  ADD PRIMARY KEY (`patient_id`),
  ADD UNIQUE KEY `national_id` (`national_id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `pill_box_serial` (`pill_box_serial`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `PATIENTS`
--
ALTER TABLE `PATIENTS`
  MODIFY `patient_id` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
