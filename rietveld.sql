SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

DROP SCHEMA IF EXISTS `Rietveld` ;
CREATE SCHEMA IF NOT EXISTS `Rietveld` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci ;
USE `Rietveld` ;

-- -----------------------------------------------------
-- Table `Rietveld`.`accounts`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Rietveld`.`accounts` ;

CREATE  TABLE IF NOT EXISTS `Rietveld`.`accounts` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `name` TINYTEXT NULL ,
  `email` VARCHAR(256) NOT NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Rietveld`.`issues`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Rietveld`.`issues` ;

CREATE  TABLE IF NOT EXISTS `Rietveld`.`issues` (
  `id` INT NOT NULL ,
  `commit` TINYINT(1) NOT NULL ,
  `closed` TINYINT(1) NOT NULL ,
  `subject` TEXT NOT NULL ,
  `modified` DATETIME NOT NULL ,
  `created` DATETIME NOT NULL ,
  `owner_id` INT NOT NULL ,
  `base_url` TEXT NOT NULL ,
  `private` TINYINT(1) NOT NULL ,
  `description` MEDIUMTEXT NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `accounts_id_idx` (`owner_id` ASC) ,
  CONSTRAINT `owner_id`
    FOREIGN KEY (`owner_id` )
    REFERENCES `Rietveld`.`accounts` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Rietveld`.`messages`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Rietveld`.`messages` ;

CREATE  TABLE IF NOT EXISTS `Rietveld`.`messages` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `sender_id` INT NOT NULL ,
  `text` MEDIUMTEXT NOT NULL ,
  `disapproval` TINYINT(1) NOT NULL DEFAULT FALSE ,
  `date` DATETIME NOT NULL ,
  `approval` TINYINT(1) NOT NULL ,
  `issue_id` INT NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `Issue_id_idx` (`issue_id` ASC) ,
  INDEX `sender_id_idx` (`sender_id` ASC) ,
  CONSTRAINT `issue_id`
    FOREIGN KEY (`issue_id` )
    REFERENCES `Rietveld`.`issues` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `sender_id`
    FOREIGN KEY (`sender_id` )
    REFERENCES `Rietveld`.`accounts` (`id` )
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
  CONSTRAINT `sender_message_id`
    FOREIGN KEY (`message_id` )
    REFERENCES `Rietveld`.`messages` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `sender_account_id`
    FOREIGN KEY (`account_id` )
    REFERENCES `Rietveld`.`accounts` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Rietveld`.`df`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Rietveld`.`df` ;

CREATE  TABLE IF NOT EXISTS `Rietveld`.`df` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `message_id` INT NOT NULL ,
  `account_id` INT NOT NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Rietveld`.`patchsets`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Rietveld`.`patchsets` ;

CREATE  TABLE IF NOT EXISTS `Rietveld`.`patchsets` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `patchset_id` INT NOT NULL ,
  `issue_id` INT NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `Issue_id_idx` (`issue_id` ASC) ,
  CONSTRAINT `patchset_issue_id`
    FOREIGN KEY (`issue_id` )
    REFERENCES `Rietveld`.`issues` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Rietveld`.`issue_reviewers`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Rietveld`.`issue_reviewers` ;

CREATE  TABLE IF NOT EXISTS `Rietveld`.`issue_reviewers` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `issue_id` INT NOT NULL ,
  `account_id` INT NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `reviewers_issue_id_idx` (`issue_id` ASC) ,
  INDEX `reviewers_account_id_idx` (`account_id` ASC) ,
  CONSTRAINT `issue_reviewers_issue_id`
    FOREIGN KEY (`issue_id` )
    REFERENCES `Rietveld`.`issues` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `issue_reviewers_account_id`
    FOREIGN KEY (`account_id` )
    REFERENCES `Rietveld`.`accounts` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Rietveld`.`message_recipients`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Rietveld`.`message_recipients` ;

CREATE  TABLE IF NOT EXISTS `Rietveld`.`message_recipients` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `message_id` INT NOT NULL ,
  `account_id` INT NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `reviewers_account_id_idx` (`account_id` ASC) ,
  INDEX `message_recipients_idx` (`message_id` ASC) ,
  CONSTRAINT `message_recipients_message_id`
    FOREIGN KEY (`message_id` )
    REFERENCES `Rietveld`.`messages` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `message_recipients_account_id`
    FOREIGN KEY (`account_id` )
    REFERENCES `Rietveld`.`accounts` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Rietveld`.`issue_ccs`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Rietveld`.`issue_ccs` ;

CREATE  TABLE IF NOT EXISTS `Rietveld`.`issue_ccs` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `issue_id` INT NOT NULL ,
  `account_id` INT NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `reviewers_issue_id_idx` (`issue_id` ASC) ,
  INDEX `reviewers_account_id_idx` (`account_id` ASC) ,
  CONSTRAINT `issue_ccs_issue_id`
    FOREIGN KEY (`issue_id` )
    REFERENCES `Rietveld`.`issues` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `issue_ccs_account_id`
    FOREIGN KEY (`account_id` )
    REFERENCES `Rietveld`.`accounts` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

USE `Rietveld` ;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
