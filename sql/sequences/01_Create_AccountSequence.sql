/*
===========================================================
Object Name : core.seq_AccountNumber
Description : Generates unique sequence values for
              Banking Account Numbers.
Author      : Raju Nalla
Project     : Enterprise Banking Data Platform
Sprint      : Sprint 1 - Banking Database Design
===========================================================
*/

-- Drop sequence if it already exists (useful during development)
IF EXISTS (
    SELECT 1
    FROM sys.sequences
    WHERE name = 'seq_AccountNumber'
      AND SCHEMA_NAME(schema_id) = 'core'
)
BEGIN
    DROP SEQUENCE core.seq_AccountNumber;
END;
GO

-- Create sequence
CREATE SEQUENCE core.seq_AccountNumber
    AS BIGINT
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    NO MAXVALUE
    NO CYCLE
    CACHE 100;
GO



SELECT NEXT VALUE FOR core.seq_AccountNumber AS SequenceValue;
GO

SELECT NEXT VALUE FOR core.seq_AccountNumber AS SequenceValue;
GO

SELECT NEXT VALUE FOR core.seq_AccountNumber AS SequenceValue;
GO