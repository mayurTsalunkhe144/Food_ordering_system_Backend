select * from sys.tables;

use Food_ordering_system;

select * from FoodOrderingSystem.Users;

alter TABLE FoodOrderingSystem.Users
ALTER COLUMN [Role] int NOT NULL;



 alter TABLE FoodOrderingSystem.Users
 drop CONSTRAINT [CK__Users__Role__38996AB5];


alter TABLE FoodOrderingSystem.Users
add CONSTRAINT [CK__Users__Role] CHECK (([Role]>(0)));

alter TABLE FoodOrderingSystem.Users
add CONSTRAINT [FK__Users__Roles__RoleID] FOREIGN KEY ([Role]) REFERENCES [FoodOrderingSystem].[Roles] ([RoleID]);



SELECT 
    tc.CONSTRAINT_NAME,
    tc.CONSTRAINT_TYPE,
    kcu.COLUMN_NAME
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS tc
JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS kcu
    ON tc.CONSTRAINT_NAME = kcu.CONSTRAINT_NAME
WHERE tc.TABLE_NAME = 'Users'
  AND tc.CONSTRAINT_TYPE = 'UNIQUE';



ALTER TABLE FoodOrderingSystem.Users
DROP CONSTRAINT UQ__Users__A9D1053466F89BE5;


alter TABLE FoodOrderingSystem.Users
alter column [Email] NVARCHAR(50) not null;

ALTER TABLE FoodOrderingSystem.Users
ADD CONSTRAINT UQ_Users_Email UNIQUE (Email);



SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'FoodOrderingSystem.Users';


EXEC sp_help 'FoodOrderingSystem.Users';




create TABLE FoodOrderingSystem.Roles(
    RoleID int primary key,
    RoleName varchar(50) not null,
    Description varchar(500) not null
);