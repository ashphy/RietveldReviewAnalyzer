SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

DROP SCHEMA IF EXISTS `Rietveld` ;
CREATE SCHEMA IF NOT EXISTS `Rietveld` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `Rietveld` ;

-- -----------------------------------------------------
-- Table `Rietveld`.`account`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Rietveld`.`account` ;

CREATE  TABLE IF NOT EXISTS `Rietveld`.`account` (
  `id` INT NOT NULL ,
  `name` TINYTEXT NULL ,
  `email` VARCHAR(256) NOT NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Rietveld`.`issue`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Rietveld`.`issue` ;

CREATE  TABLE IF NOT EXISTS `Rietveld`.`issue` (
  `id` INT NOT NULL ,
  `commit` TINYINT(1) NOT NULL ,
  `close` TINYINT(1) NOT NULL ,
  `subject` TEXT NOT NULL ,
  `modified` DATETIME NOT NULL ,
  `created` DATETIME NOT NULL ,
  `owner` INT NOT NULL ,
  `base_url` TEXT NOT NULL ,
  `private` TINYINT(1) NOT NULL ,
  `description` MEDIUMTEXT NOT NULL ,
  PRIMARY KEY (`id`) ,
  CONSTRAINT `owner_id`
    FOREIGN KEY (`id` )
    REFERENCES `Rietveld`.`account` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Rietveld`.`message`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Rietveld`.`message` ;

CREATE  TABLE IF NOT EXISTS `Rietveld`.`message` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `sender_id` INT NOT NULL ,
  `text` TEXT NOT NULL ,
  `disapproval` TINYINT(1) NOT NULL DEFAULT FALSE ,
  `date` DATETIME NOT NULL ,
  `approval` TINYINT(1) NOT NULL ,
  `issue_id` INT NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `Issue_id_idx` (`issue_id` ASC) ,
  CONSTRAINT `Issue_id`
    FOREIGN KEY (`issue_id` )
    REFERENCES `Rietveld`.`issue` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `sender_id`
    FOREIGN KEY (`id` )
    REFERENCES `Rietveld`.`account` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Rietveld`.`sender`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Rietveld`.`sender` ;

CREATE  TABLE IF NOT EXISTS `Rietveld`.`sender` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `message_id` INT NOT NULL ,
  `account_id` INT NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `Account_id_idx` (`account_id` ASC) ,
  CONSTRAINT `Message_id`
    FOREIGN KEY (`message_id` )
    REFERENCES `Rietveld`.`message` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `Account_id`
    FOREIGN KEY (`account_id` )
    REFERENCES `Rietveld`.`account` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Rietveld`.`recipient`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Rietveld`.`recipient` ;

CREATE  TABLE IF NOT EXISTS `Rietveld`.`recipient` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `message_id` INT NOT NULL ,
  `account_id` INT NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `Account_id_idx` (`account_id` ASC) ,
  CONSTRAINT `Message_id`
    FOREIGN KEY (`message_id` )
    REFERENCES `Rietveld`.`message` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `Account_id`
    FOREIGN KEY (`account_id` )
    REFERENCES `Rietveld`.`account` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Rietveld`.`patchset`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Rietveld`.`patchset` ;

CREATE  TABLE IF NOT EXISTS `Rietveld`.`patchset` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `patchset_id` INT NOT NULL ,
  `issue_id` INT NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `Issue_id_idx` (`issue_id` ASC) ,
  CONSTRAINT `Issue_id`
    FOREIGN KEY (`issue_id` )
    REFERENCES `Rietveld`.`issue` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

USE `Rietveld` ;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
