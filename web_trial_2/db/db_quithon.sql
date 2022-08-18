-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 18, 2022 at 04:44 AM
-- Server version: 10.4.24-MariaDB
-- PHP Version: 8.1.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_quithon`
--

-- --------------------------------------------------------

--
-- Table structure for table `grade`
--

CREATE TABLE `grade` (
  `gid` int(11) NOT NULL,
  `subject` varchar(50) NOT NULL,
  `sid` int(11) NOT NULL,
  `score` float NOT NULL,
  `done` date NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `grade`
--

INSERT INTO `grade` (`gid`, `subject`, `sid`, `score`, `done`) VALUES
(1, 'Function dan Dictionary', 1, 100, '2022-08-10'),
(2, 'Function dan Dictionary', 1, 50, '2022-08-11'),
(3, 'Dasar Python', 1, 80, '2022-08-11'),
(4, 'Function dan Dictionary', 1, 100, '2022-08-12'),
(5, 'Dasar Python', 1, 70, '2022-08-12');

-- --------------------------------------------------------

--
-- Table structure for table `quiz`
--

CREATE TABLE `quiz` (
  `qid` int(11) NOT NULL,
  `subject` varchar(50) NOT NULL,
  `question` varchar(500) NOT NULL,
  `option1` varchar(200) DEFAULT NULL,
  `option2` varchar(200) DEFAULT NULL,
  `option3` varchar(200) DEFAULT NULL,
  `option4` varchar(200) DEFAULT NULL,
  `answer` smallint(6) DEFAULT NULL,
  `btncol` varchar(10) NOT NULL,
  `status` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `quiz`
--

INSERT INTO `quiz` (`qid`, `subject`, `question`, `option1`, `option2`, `option3`, `option4`, `answer`, `btncol`, `status`) VALUES
(1, 'Function dan Dictionary', 'Manakah pernyataan yang benar di antara keempat pernyataan di bawah ini?', 'Dictionary bersifat mutable', 'Item pada dictionary dapat diakses berdasarkan posisinya', 'Semua key di dalam dictionary harus berasal dari tipe data yang sama', 'Sebuah dictionary dapat berisi objek apapun kecuali dictionary lain', 1, '', ''),
(2, 'List dan Tuple', 'Manakah pernyataan yang benar tentang list dari keempat pernyataan di bawah ini?', 'Sebuah objek mungkin muncul di dalam sebuah list lebih dari sekali', 'Semua elemen di dalam list harus merupakan tipe data yang sama', 'Sebuah list mungkin berisi objek dengan tipe data selain list', 'list_1 = [\'a\',\'b\',\'c\'] dan list_2 = [\'c\',\'b\',\'a\'] merepresentasikan list yang sama', 1, '', ''),
(4, 'Function dan Dictionary', 'Fungsi didefinisikan dengan menggunakan syntax:', 'fun', 'func', 'def', 'function', 3, '', ''),
(5, 'Dasar Python', 'Siapa yang membuat Python pada tahun 1990?', 'Dennis Ritchie', 'Guido Van Rossum', 'Alan Turing', 'Douglas Englebart', 2, '', ''),
(6, 'Dasar Python', 'Tahun berapa bahasa pemrograman Python mulai dikembangkan?', '1995', '1990', '1998', '1999', 1, '', ''),
(7, 'Dasar Python', 'Python tergolong pada bahasa pemrograman tingkat apa?', 'Tingkat rendah', 'Tingkat sedang', 'Tingkat tinggi', 'Semua salah', 3, '', ''),
(8, 'Dasar Python', 'Pilih syntax yang benar untuk mengeluarkan output: Hello World!', 'print Hello World!', 'print:(“Hello World!”)', 'print(Hello World!)', 'print(‘Hello World!’)', 4, '', ''),
(9, 'Dasar Python', 'Bagaimana cara menambahkan keterangan (comment) pada kode Python?', '/* Keterangan */', '# Keterangan', '* Keterangan', '// Keterangan', 2, '', ''),
(10, 'Dasar Python', 'Apa ekstensi file Python?', '.python', '.p', '.py', '.pyt', 3, '', ''),
(11, 'Dasar Python', 'Dalam kode Python, penulisan ‘Quithon’ dan “Quithon” sama-sama untuk merepresentasikan string.', 'Benar', 'Salah, \'Quithon\' bukan string.', 'Salah, \"Quithon\" bukan string.', 'Salah, keduanya bukan cara merepresentasikan string.', 1, '', ''),
(12, 'Dasar Python', 'Operator ** digunakan untuk:', 'Melakukan operasi penambahan', 'Melakukan operasi perkalian', 'Tidak ada dalam Python', 'Melakukan operasi perpangkatan', 4, '', ''),
(13, 'Dasar Python', 'Operator yang digunakan untuk melakukan operasi perkalian adalah:', 'x', '**', '%', '*', 4, '', ''),
(14, 'Dasar Python', 'Jika variabel a = \'hello\', maka output dari print(a) adalah:', '\'hello\'', '\"hello\"', 'hello', 'Terjadi error', 3, '', '');

-- --------------------------------------------------------

--
-- Table structure for table `student`
--

CREATE TABLE `student` (
  `sid` int(11) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(100) NOT NULL,
  `name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `student`
--

INSERT INTO `student` (`sid`, `email`, `password`, `name`) VALUES
(1, 'aldaputri@gmail.com', 'abc123456', 'Alda');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `grade`
--
ALTER TABLE `grade`
  ADD PRIMARY KEY (`gid`),
  ADD KEY `sid` (`sid`);

--
-- Indexes for table `quiz`
--
ALTER TABLE `quiz`
  ADD PRIMARY KEY (`qid`);

--
-- Indexes for table `student`
--
ALTER TABLE `student`
  ADD PRIMARY KEY (`sid`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `grade`
--
ALTER TABLE `grade`
  MODIFY `gid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `quiz`
--
ALTER TABLE `quiz`
  MODIFY `qid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `student`
--
ALTER TABLE `student`
  MODIFY `sid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `grade`
--
ALTER TABLE `grade`
  ADD CONSTRAINT `grade_ibfk_1` FOREIGN KEY (`sid`) REFERENCES `student` (`sid`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
