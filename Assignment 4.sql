-- Factorial Function
--Create a scalar-valued function that returns the factorial of a number you gave it.

CREATE FUNCTION dbo.ReturnFactorial(@n INT)
RETURNS INT
AS
BEGIN
    DECLARE @result INT;

-- Base case: factorial of 0 or 1 is 1

    IF @n <= 1
        SET @result = 1;
    ELSE

-- Recursive case: multiply @n by factorial of (@n - 1)

        SET @result = @n * dbo.ReturnFactorial(@n - 1);

    RETURN @result;
END;

--Run

SELECT dbo.ReturnFactorial(4);
