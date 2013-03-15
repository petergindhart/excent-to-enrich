IF OBJECT_ID('Datavalidation.udf_IsInteger') IS NOT NULL
  DROP FUNCTION Datavalidation.udf_IsInteger
GO
CREATE FUNCTION Datavalidation.udf_IsInteger(@Value VARCHAR(8))
  RETURNS BIT
    AS
    BEGIN
     
      RETURN ISNULL(
         (SELECT CASE WHEN CHARINDEX('.', @Value) > 0
                      THEN CASE WHEN CONVERT(INT, PARSENAME(@Value, 1)) <> 0
                                THEN 0
                                ELSE 1
                                END
                      ELSE 1
                      END
          WHERE ISNUMERIC(@Value + 'e0') = 1), 0)
     
    END
    
  