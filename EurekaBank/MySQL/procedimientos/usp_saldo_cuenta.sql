DELIMITER $$

DROP PROCEDURE IF EXISTS usp_egcc_saldo_cuenta$$

CREATE PROCEDURE usp_egcc_saldo_cuenta
(IN p_cuenta char(8), OUT p_saldo decimal(12,2)) 
BEGIN
	
	select dec_cuensaldo into p_saldo
	from cuenta
	where chr_cuencodigo = p_cuenta;
	
END$$

DELIMITER ;

/*

CALL usp_saldo_cuenta('00200002',@saldo);
select @saldo;

CALL usp_saldo_cuenta('00200008',@saldo);
select @saldo;

*/