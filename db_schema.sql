SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE SCHEMA IF NOT EXISTS `loan-schema` DEFAULT CHARACTER SET latin1 ;
CREATE SCHEMA IF NOT EXISTS `asset-schema` ;

-- -----------------------------------------------------
-- Table `loan-schema`.`m_loan`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `loan-schema`.`m_loan` (
  `id` BIGINT(20) NOT NULL AUTO_INCREMENT,
  `account_no` VARCHAR(20) NOT NULL,
  `disbursedon_date` DATE NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `loan_account_no_UNIQUE` (`account_no` ASC)
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COMMENT = 'Loans issued';


-- -----------------------------------------------------
-- Table `loan-schema`.`m_loan_repayment_schedule`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `loan-schema`.`m_loan_repayment_schedule` (
  `id` BIGINT(20) NOT NULL AUTO_INCREMENT,
  `loan_id` BIGINT(20) NOT NULL,
  `duedate` DATE NOT NULL,
  `principal_amount` DECIMAL(19,6) NULL DEFAULT NULL,
  `interest_amount` DECIMAL(19,6) NULL DEFAULT NULL,
  `fee_charges_amount` DECIMAL(19,6) NULL DEFAULT NULL,
  `penalty_charges_amount` DECIMAL(19,6) NULL DEFAULT NULL,
  `completed_derived` BIT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  INDEX `FK488B92AA40BE0710` (`loan_id` ASC),
  CONSTRAINT `FK488B92AA40BE0710`
    FOREIGN KEY (`loan_id`)
    REFERENCES `loan-schema`.`m_loan` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `loan-schema`.`m_loan_transaction`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `loan-schema`.`m_loan_transaction` (
  `id` BIGINT(20) NOT NULL AUTO_INCREMENT,
  `loan_id` BIGINT(20) NOT NULL,
  `is_reversed` TINYINT(1) NOT NULL,
  `transaction_date` DATE NOT NULL,
  `amount` DECIMAL(19,6) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `FKCFCEA42640BE0710` (`loan_id` ASC),
  CONSTRAINT `FKCFCEA42640BE0710`
    FOREIGN KEY (`loan_id`)
    REFERENCES `loan-schema`.`m_loan` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;




-- -----------------------------------------------------
-- Table `asset-schema`.`vehicle_make`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `asset-schema`.`vehicle_make` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `asset-schema`.`vehicle_model`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `asset-schema`.`vehicle_model` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `vehicle_make_id` INT NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_vehicle_model_vehicle_make_idx` (`vehicle_make_id` ASC),
  CONSTRAINT `fk_vehicle_model_vehicle_make`
    FOREIGN KEY (`vehicle_make_id`)
    REFERENCES `asset-schema`.`vehicle_make` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `asset-schema`.`asset`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `asset-schema`.`asset` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `model_id` INT NULL,
  `registration_no` VARCHAR(50) NULL,
  `chassis_no` VARCHAR(50) NULL,
  `m_loan_id` BIGINT NULL COMMENT 'Current loan assigned to asset',
  PRIMARY KEY (`id`),
  INDEX `fk_asset_m_loan_idx` (`m_loan_id` ASC),
  INDEX `fk_asset_vehicle_model_idx` (`model_id` ASC),
  UNIQUE INDEX `chassis_no_UNIQUE` (`chassis_no` ASC),
  INDEX `registration_no_idx` (`registration_no` ASC),
  CONSTRAINT `fk_asset_m_loan`
    FOREIGN KEY (`m_loan_id`)
    REFERENCES `loan-schema`.`m_loan` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_asset_vehicle_model`
    FOREIGN KEY (`model_id`)
    REFERENCES `asset-schema`.`vehicle_model` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Asset data';


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;



