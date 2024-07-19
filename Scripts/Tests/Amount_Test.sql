

CREATE OR ALTER FUNCTION report.CALCULATE_LOSS_VALUE(@value VARCHAR(30))
RETURNS DECIMAL(19, 2)
AS
	BEGIN
		DECLARE
			@currency AS VARCHAR(1),
			@amount AS DECIMAL(19, 2),
			@to_return AS DECIMAL(19, 2);
		
		BEGIN
			IF (@value LIKE '%,%')
				BEGIN
					DECLARE @value_to_evaluate AS VARCHAR(30)
					DECLARE cur CURSOR DYNAMIC FORWARD_ONLY
								FOR SELECT * FROM STRING_SPLIT(@value, ',');
					OPEN cur;
					FETCH NEXT FROM cur INTO @value_to_evaluate;
					WHILE @@FETCH_STATUS = 0
						BEGIN
							IF (TRY_CAST(@value_to_evaluate AS DECIMAL) IS NOT NULL)
								SET @amount = CAST(@value_to_evaluate AS DECIMAL(19, 2));
							ELSE IF (TRY_CAST(@value_to_evaluate AS DECIMAL) IS NULL)
								SET @currency = @value_to_evaluate
							FETCH NEXT FROM cur INTO @value_to_evaluate;
						END;
					CLOSE cur;
					DEALLOCATE cur;
					BEGIN
						SET @to_return = (SELECT CASE
													WHEN @currency = 'Q' THEN @amount / 7.5
													WHEN @currency = '$' THEN @amount
													ELSE @amount
												END);
					END
				END;
		END;
		RETURN @to_return;
	END;

SELECT report.CALCULATE_LOSS_VALUE('$,19000.00')
	