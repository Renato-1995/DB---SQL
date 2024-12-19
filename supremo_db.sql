-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Tempo de geração: 16-Jun-2024 às 23:36
-- Versão do servidor: 10.4.28-MariaDB
-- versão do PHP: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `supremo_db`
--

DELIMITER $$
--
-- Procedimentos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `AtualizarCorAutomovel` (IN `num_serie` INT, IN `nova_cor` VARCHAR(50))   BEGIN
    DECLARE automovel_existente INT;

    SET automovel_existente = (SELECT COUNT(*) FROM automovel WHERE numero_serie = num_serie);
    
    IF automovel_existente = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Automóvel não encontrado.';
    ELSE
        UPDATE automovel
        SET cor = nova_cor
        WHERE numero_serie = num_serie;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `AtualizarPrecoAutomovel` (IN `automovelId` INT, IN `novoPreco` DECIMAL(10,2))   BEGIN
    UPDATE automovel
    SET preco = novoPreco
    WHERE automovel_id = automovelId;
END$$

--
-- Funções
--
CREATE DEFINER=`root`@`localhost` FUNCTION `ContarAutomoveisPorProprietario` (`proprietarioId` INT) RETURNS INT(11)  BEGIN
    DECLARE contador INT;
    SELECT COUNT(*) INTO contador FROM automovel WHERE Proprietario = proprietarioId;
    RETURN contador;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `MediaPrecosAutomoveis` () RETURNS DECIMAL(10,2)  BEGIN
    DECLARE media DECIMAL(10,2);
    SELECT AVG(preco) INTO media FROM automovel;
    RETURN media;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura stand-in para vista `automoveisporproprietario`
-- (Veja abaixo para a view atual)
--
CREATE TABLE `automoveisporproprietario` (
`nome` varchar(100)
,`matricula` int(11)
,`preco` decimal(10,2)
);

-- --------------------------------------------------------

--
-- Estrutura da tabela `automovel`
--

CREATE TABLE `automovel` (
  `automovel_id` int(11) NOT NULL,
  `ano_fabrico` int(11) DEFAULT NULL,
  `cor` varchar(50) DEFAULT NULL,
  `numero_serie` int(11) DEFAULT NULL,
  `cilindrada` int(11) DEFAULT NULL,
  `matricula` int(11) DEFAULT NULL,
  `preco` decimal(10,2) DEFAULT NULL,
  `modelo` int(11) DEFAULT NULL,
  `Proprietario` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `automovel`
--

INSERT INTO `automovel` (`automovel_id`, `ano_fabrico`, `cor`, `numero_serie`, `cilindrada`, `matricula`, `preco`, `modelo`, `Proprietario`) VALUES
(1, 1998, 'Marron', 681279137, 1000, 1, 3999.99, 1, 4),
(2, 2024, 'vermelho', 751279137, 1500, 2, 19999.99, 2, 5),
(3, 2001, 'vermelho', 164278137, 1200, 3, 18000000.00, 3, 3),
(4, 2012, 'vermelho', 561279137, 1500, 4, 5999.99, 4, 2),
(5, 2017, 'vermelho', 891278137, 1500, 5, 9999.99, 5, NULL);

--
-- Acionadores `automovel`
--
DELIMITER $$
CREATE TRIGGER `ImpedirReducaoPreco` BEFORE UPDATE ON `automovel` FOR EACH ROW BEGIN
    IF NEW.preco < OLD.preco THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O preço do automóvel não pode ser reduzido.';
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `VerificarPrecoMinimo` BEFORE INSERT ON `automovel` FOR EACH ROW BEGIN
    IF NEW.preco < 1000 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'O preço do automóvel não pode ser inferior a 1000.';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `fornecedor`
--

CREATE TABLE `fornecedor` (
  `fornecedor_id` int(11) NOT NULL,
  `nome` varchar(100) DEFAULT NULL,
  `telefone` int(11) DEFAULT NULL,
  `nacionalidade` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `fornecedor`
--

INSERT INTO `fornecedor` (`fornecedor_id`, `nome`, `telefone`, `nacionalidade`) VALUES
(1, 'Bosch', NULL, 'Alemã'),
(2, 'Continental', NULL, 'Alemã'),
(3, 'TMG Automotive', NULL, 'Portuguesa'),
(4, 'AUTODOC', NULL, 'Alemã'),
(5, 'Delphi Technologies', NULL, 'Britânica');

-- --------------------------------------------------------

--
-- Estrutura da tabela `marca`
--

CREATE TABLE `marca` (
  `marca_id` int(11) NOT NULL,
  `nome` varchar(100) DEFAULT NULL,
  `nacionalidade` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `marca`
--

INSERT INTO `marca` (`marca_id`, `nome`, `nacionalidade`) VALUES
(1, 'Fiat', 'Italiana'),
(2, 'Ford', 'Americana'),
(3, 'Renault', 'Francesa'),
(4, 'Volkswagen', 'Alemã'),
(5, 'Audi', 'Alemã');

-- --------------------------------------------------------

--
-- Estrutura da tabela `marca_fornecedor`
--

CREATE TABLE `marca_fornecedor` (
  `fornecedor_id` int(11) NOT NULL,
  `marca_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `marca_fornecedor`
--

INSERT INTO `marca_fornecedor` (`fornecedor_id`, `marca_id`) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

-- --------------------------------------------------------

--
-- Estrutura da tabela `matricula`
--

CREATE TABLE `matricula` (
  `matricula_id` int(11) NOT NULL,
  `numero` varchar(11) DEFAULT NULL,
  `ano` int(11) DEFAULT NULL,
  `mes` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `matricula`
--

INSERT INTO `matricula` (`matricula_id`, `numero`, `ano`, `mes`) VALUES
(1, '49-51-BF', 1995, 'abril'),
(2, '40-45-FB', 2024, 'fevereiro'),
(3, '31-69-CD', 2001, 'dezembro'),
(4, '48-50-BF', 2012, 'junho'),
(5, '56-12-VF', 2017, 'outubro'),
(6, '12-68-FO', 2024, 'junho');

-- --------------------------------------------------------

--
-- Estrutura da tabela `modelo`
--

CREATE TABLE `modelo` (
  `modelo_id` int(11) NOT NULL,
  `nome` varchar(100) DEFAULT NULL,
  `ano_concessao` int(11) DEFAULT NULL,
  `marca` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `modelo`
--

INSERT INTO `modelo` (`modelo_id`, `nome`, `ano_concessao`, `marca`) VALUES
(1, 'Multipla', 1998, 1),
(2, 'Puma', 2024, 2),
(3, 'Clio', 2001, 3),
(4, 'Polo', 2012, 4),
(5, 'Megane', 2017, 3),
(8, 'RS3', 2024, 5);

-- --------------------------------------------------------

--
-- Estrutura da tabela `proprietario`
--

CREATE TABLE `proprietario` (
  `proprietario_id` int(11) NOT NULL,
  `nome` varchar(100) DEFAULT NULL,
  `morada` varchar(200) DEFAULT NULL,
  `nif` int(11) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `contacto` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `proprietario`
--

INSERT INTO `proprietario` (`proprietario_id`, `nome`, `morada`, `nif`, `email`, `contacto`) VALUES
(1, 'Asdrubal Pinheiro', 'Rua do Quarto 22', 234987456, 'asdrubalpinheiro@gmail.com', 915681616),
(2, 'Marta Maria', 'Rua da Ponta 32', 334927456, 'martamaria@gmail.com', 915581515),
(3, 'Caio Pinto', 'Rua do Brasil 52', 534987456, 'caiopinto@gmail.com', 915681313),
(4, 'Marcelo Rebelo de Sousa', 'Palácio de Cristal 25', 734987456, 'marcelopresidente@portugal.pt', 252875561),
(5, 'Jacinto Pinto', 'Rua do Brasil 51', 246987456, 'jacintopinto@gmail.com', 915611616);

-- --------------------------------------------------------

--
-- Estrutura stand-in para vista `proprietariocarromaiscaro`
-- (Veja abaixo para a view atual)
--
CREATE TABLE `proprietariocarromaiscaro` (
`nome` varchar(100)
,`matricula` int(11)
,`preco` decimal(10,2)
);

-- --------------------------------------------------------

--
-- Estrutura stand-in para vista `total_precos_veiculos`
-- (Veja abaixo para a view atual)
--
CREATE TABLE `total_precos_veiculos` (
`preco_total` decimal(32,2)
);

-- --------------------------------------------------------

--
-- Estrutura para vista `automoveisporproprietario`
--
DROP TABLE IF EXISTS `automoveisporproprietario`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `automoveisporproprietario`  AS SELECT `p`.`nome` AS `nome`, `a`.`matricula` AS `matricula`, `a`.`preco` AS `preco` FROM (`automovel` `a` join `proprietario` `p` on(`a`.`Proprietario` = `p`.`proprietario_id`)) ;

-- --------------------------------------------------------

--
-- Estrutura para vista `proprietariocarromaiscaro`
--
DROP TABLE IF EXISTS `proprietariocarromaiscaro`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `proprietariocarromaiscaro`  AS SELECT `p`.`nome` AS `nome`, `a`.`matricula` AS `matricula`, `a`.`preco` AS `preco` FROM (`automovel` `a` join `proprietario` `p` on(`a`.`Proprietario` = `p`.`proprietario_id`)) WHERE `a`.`preco` = (select max(`automovel`.`preco`) from `automovel`) ;

-- --------------------------------------------------------

--
-- Estrutura para vista `total_precos_veiculos`
--
DROP TABLE IF EXISTS `total_precos_veiculos`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `total_precos_veiculos`  AS SELECT sum(`automovel`.`preco`) AS `preco_total` FROM `automovel` ;

--
-- Índices para tabelas despejadas
--

--
-- Índices para tabela `automovel`
--
ALTER TABLE `automovel`
  ADD PRIMARY KEY (`automovel_id`),
  ADD UNIQUE KEY `matricula_2` (`matricula`),
  ADD KEY `matricula` (`matricula`),
  ADD KEY `modelo` (`modelo`),
  ADD KEY `Proprietario` (`Proprietario`);

--
-- Índices para tabela `fornecedor`
--
ALTER TABLE `fornecedor`
  ADD PRIMARY KEY (`fornecedor_id`);

--
-- Índices para tabela `marca`
--
ALTER TABLE `marca`
  ADD PRIMARY KEY (`marca_id`);

--
-- Índices para tabela `marca_fornecedor`
--
ALTER TABLE `marca_fornecedor`
  ADD KEY `fornecedor_id` (`fornecedor_id`),
  ADD KEY `marca_id` (`marca_id`);

--
-- Índices para tabela `matricula`
--
ALTER TABLE `matricula`
  ADD PRIMARY KEY (`matricula_id`);

--
-- Índices para tabela `modelo`
--
ALTER TABLE `modelo`
  ADD PRIMARY KEY (`modelo_id`),
  ADD KEY `marca` (`marca`);

--
-- Índices para tabela `proprietario`
--
ALTER TABLE `proprietario`
  ADD PRIMARY KEY (`proprietario_id`);

--
-- AUTO_INCREMENT de tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `automovel`
--
ALTER TABLE `automovel`
  MODIFY `automovel_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de tabela `fornecedor`
--
ALTER TABLE `fornecedor`
  MODIFY `fornecedor_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de tabela `marca`
--
ALTER TABLE `marca`
  MODIFY `marca_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de tabela `matricula`
--
ALTER TABLE `matricula`
  MODIFY `matricula_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de tabela `modelo`
--
ALTER TABLE `modelo`
  MODIFY `modelo_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de tabela `proprietario`
--
ALTER TABLE `proprietario`
  MODIFY `proprietario_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Restrições para despejos de tabelas
--

--
-- Limitadores para a tabela `automovel`
--
ALTER TABLE `automovel`
  ADD CONSTRAINT `automovel_ibfk_1` FOREIGN KEY (`matricula`) REFERENCES `matricula` (`matricula_id`),
  ADD CONSTRAINT `automovel_ibfk_2` FOREIGN KEY (`modelo`) REFERENCES `modelo` (`modelo_id`),
  ADD CONSTRAINT `automovel_ibfk_3` FOREIGN KEY (`Proprietario`) REFERENCES `proprietario` (`proprietario_id`);

--
-- Limitadores para a tabela `marca_fornecedor`
--
ALTER TABLE `marca_fornecedor`
  ADD CONSTRAINT `marca_fornecedor_ibfk_1` FOREIGN KEY (`fornecedor_id`) REFERENCES `fornecedor` (`fornecedor_id`),
  ADD CONSTRAINT `marca_fornecedor_ibfk_2` FOREIGN KEY (`marca_id`) REFERENCES `marca` (`marca_id`);

--
-- Limitadores para a tabela `modelo`
--
ALTER TABLE `modelo`
  ADD CONSTRAINT `modelo_ibfk_1` FOREIGN KEY (`marca`) REFERENCES `marca` (`marca_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
