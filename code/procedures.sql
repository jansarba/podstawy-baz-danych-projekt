CREATE PROCEDURE AddOrder
    @StudentID INT,
    @Payment MONEY
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Dodaj zamówienie do tabeli Orders
        INSERT INTO Orders (StudentID, Payment, OrderDate)
        VALUES (@StudentID, @Payment, GETDATE());

        -- Pobierz ID nowo utworzonego zamówienia
        DECLARE @OrderID INT = SCOPE_IDENTITY();

        -- Zwróć nowo utworzone OrderID
        SELECT @OrderID AS OrderID;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;

CREATE PROCEDURE [dbo].[AddOrderDetails]
    @OrderID INT,
	@OrderDetailsID INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Dodaj szczegóły zamówienia
        INSERT INTO OrderDetails (OrderID, PaymentDate)
        VALUES (@OrderID, GETDATE());

        -- Pobierz ID nowo utworzonego szczegółu zamówienia
        SET @OrderDetailsID = SCOPE_IDENTITY();

        -- Zwróć nowo utworzone OrderDetailsID
        SELECT @OrderDetailsID AS OrderDetailsID;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;

/****** Utworzenie nowej procedury ******/
CREATE PROCEDURE [dbo].[AddOrderDetailsAndCourses]
    @OrderID INT, -- Identyfikator zamówienia
    @CourseID INT,
    @BuyPrice MONEY
AS
BEGIN
    SET NOCOUNT ON;

    -- Deklaracje zmiennych
    DECLARE @OrderDetailsID INT;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Sprawdzenie danych wejściowych
        IF @OrderID IS NULL OR @CourseID IS NULL OR @BuyPrice IS NULL
        BEGIN
            THROW 50002, 'Nieprawidłowe dane wejściowe.', 1;
        END

        -- Dodanie szczegółów zamówienia
        EXEC [dbo].[AddOrderDetails] 
            @OrderID = @OrderID,
            @OrderDetailsID = @OrderDetailsID OUTPUT;  -- Przekazanie zmiennej OUTPUT

        -- Sprawdzenie, czy `OrderDetailsID` zostało ustawione
        IF @OrderDetailsID IS NULL
        BEGIN
            THROW 50001, 'Nie udało się uzyskać ID szczegółów zamówienia. Operacja przerwana.', 1;
        END

        -- Dodanie szczegółów spotkania studiów do tabeli OrderStudyMeetings
        INSERT INTO OrderCourses(OrderDetailsID, CourseID, BuyPrice)
        VALUES (@OrderDetailsID, @CourseID, @BuyPrice);

        -- Zatwierdzenie transakcji
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Wycofanie transakcji w przypadku błędu
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        -- Ponowne zgłoszenie wyjątku
        THROW;
    END CATCH
END;

/****** Utworzenie nowej procedury ******/
CREATE PROCEDURE [dbo].[AddOrderDetailsAndMeeting]
    @OrderID INT, -- Identyfikator zamówienia
    @StudyMeetingID INT,
    @BuyPrice MONEY
AS
BEGIN
    SET NOCOUNT ON;

    -- Deklaracje zmiennych
    DECLARE @OrderDetailsID INT;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Sprawdzenie danych wejściowych
        IF @OrderID IS NULL OR @StudyMeetingID IS NULL OR @BuyPrice IS NULL
        BEGIN
            THROW 50002, 'Nieprawidłowe dane wejściowe.', 1;
        END

        -- Dodanie szczegółów zamówienia
        EXEC [dbo].[AddOrderDetails] 
            @OrderID = @OrderID,
            @OrderDetailsID = @OrderDetailsID OUTPUT;  -- Przekazanie zmiennej OUTPUT

        -- Sprawdzenie, czy `OrderDetailsID` zostało ustawione
        IF @OrderDetailsID IS NULL
        BEGIN
            THROW 50001, 'Nie udało się uzyskać ID szczegółów zamówienia. Operacja przerwana.', 1;
        END

        -- Dodanie szczegółów spotkania studiów do tabeli OrderStudyMeetings
        INSERT INTO OrderStudyMeetings(OrderDetailsID, StudyMeetingID, BuyPrice)
        VALUES (@OrderDetailsID, @StudyMeetingID, @BuyPrice);

        -- Zatwierdzenie transakcji
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Wycofanie transakcji w przypadku błędu
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        -- Ponowne zgłoszenie wyjątku
        THROW;
    END CATCH
END;

/****** Utworzenie nowej wersji procedury ******/
CREATE PROCEDURE [dbo].[AddOrderDetailsAndStudies]
    @OrderID INT, -- Identyfikator zamówienia
    @StudyID INT,
    @GradeID INT,
    @BuyPrice MONEY,
    @GradeValue INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Deklaracje zmiennych
    DECLARE @OrderDetailsID INT;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Sprawdzenie danych wejściowych
        IF @OrderID IS NULL OR @StudyID IS NULL OR @GradeID IS NULL OR @BuyPrice IS NULL OR @GradeValue IS NULL
        BEGIN
            THROW 50002, 'Nieprawidłowe dane wejściowe.', 1;
        END

        -- Dodanie szczegółów zamówienia
        EXEC [dbo].[AddOrderDetails] 
            @OrderID = @OrderID,
            @OrderDetailsID = @OrderDetailsID OUTPUT;  -- Przekazanie zmiennej OUTPUT

        -- Sprawdzenie, czy `OrderDetailsID` zostało ustawione
        IF @OrderDetailsID IS NULL
        BEGIN
            THROW 50001, 'Nie udało się uzyskać ID szczegółów zamówienia. Operacja przerwana.', 1;
        END

        -- Dodanie szczegółów studiów do tabeli OrderStudies
        INSERT INTO OrderStudies (OrderDetailsID, StudyID, GradeID, BuyPrice, GradeValue)
        VALUES (@OrderDetailsID, @StudyID, @GradeID, @BuyPrice, @GradeValue);

        -- Zatwierdzenie transakcji
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Wycofanie transakcji w przypadku błędu
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        -- Ponowne zgłoszenie wyjątku
        THROW;
    END CATCH
END;

/****** Utworzenie nowej procedury ******/
CREATE PROCEDURE [dbo].[AddOrderDetailsAndWebinars]
    @OrderID INT, -- Identyfikator zamówienia
    @WebinarID INT,
    @BuyPrice MONEY
AS
BEGIN
    SET NOCOUNT ON;

    -- Deklaracje zmiennych
    DECLARE @OrderDetailsID INT;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Sprawdzenie danych wejściowych
        IF @OrderID IS NULL OR @WebinarID IS NULL OR @BuyPrice IS NULL
        BEGIN
            THROW 50002, 'Nieprawidłowe dane wejściowe.', 1;
        END

        -- Dodanie szczegółów zamówienia
        EXEC [dbo].[AddOrderDetails] 
            @OrderID = @OrderID,
            @OrderDetailsID = @OrderDetailsID OUTPUT;  -- Przekazanie zmiennej OUTPUT

        -- Sprawdzenie, czy `OrderDetailsID` zostało ustawione
        IF @OrderDetailsID IS NULL
        BEGIN
            THROW 50001, 'Nie udało się uzyskać ID szczegółów zamówienia. Operacja przerwana.', 1;
        END

        -- Dodanie szczegółów spotkania studiów do tabeli OrderStudyMeetings
        INSERT INTO OrderWebinars(OrderDetailsID, WebinarID, BuyPrice)
        VALUES (@OrderDetailsID, @WebinarID, @BuyPrice);

        -- Zatwierdzenie transakcji
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Wycofanie transakcji w przypadku błędu
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        -- Ponowne zgłoszenie wyjątku
        THROW;
    END CATCH
END;

CREATE PROCEDURE [dbo].[AddOrderStudy]
    @OrderDetailsID INT,
    @StudyID INT,
    @GradeID INT,
    @BuyPrice MONEY,
    @GradeValue INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Dodaj szczegóły studiów do tabeli OrderStudies
        INSERT INTO OrderStudies (OrderDetailsID, StudyID, GradeID, BuyPrice, GradeValue)
        VALUES (@OrderDetailsID, @StudyID, @GradeID, @BuyPrice, @GradeValue);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;

CREATE PROCEDURE [dbo].[dodaj_pracownika]
    @FirstName VARCHAR(30),
    @LastName VARCHAR(30),
    @HireDate DATE,
    @BirthDate DATE,
    @Phone VARCHAR(15),
    @Email VARCHAR(50),
    @EmployeeTypeID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Dodawanie pracownika
    INSERT INTO Employees (FirstName, LastName, HireDate, BirthDate, Phone, Email, EmployeeTypeID)
    VALUES (@FirstName, @LastName, @HireDate, @BirthDate, @Phone, @Email, @EmployeeTypeID);

    PRINT 'Pracownik został pomyślnie dodany.';
END;

CREATE PROCEDURE dbo.dodaj_przedmiot

    @StudyID INT,
    @CoordinatorID INT,
	@ClassName VARCHAR(50),
	@ClassDescription TEXT
AS
BEGIN
    SET NOCOUNT ON;

    -- Dodawanie przedmiot
    INSERT INTO Classes(StudyID, CoordinatorID, ClassName, ClassDescription)
    VALUES (@StudyID, @CoordinatorID, @ClassName, @ClassDescription);

    -- Pobieranie ID nowo dodanego przedmiotu
    DECLARE @ClassID INT = SCOPE_IDENTITY();

    PRINT 'Przedmiot zostały pomyślnie dodany.';
END;

CREATE PROCEDURE [dbo].[dodaj_studenta]

    @FirstName VARCHAR(30),
    @LastName VARCHAR(30),
	@Address VARCHAR(30),
	@CityID INT,
	@Zip VARCHAR(10),
	@Phone VARCHAR(15),
	@Email VARCHAR(50),
	@ReturnID INT OUTPUT
	
AS
BEGIN
    SET NOCOUNT ON;

    -- Dodawanie studenta
    INSERT INTO Students(FirstName, LastName, Address, CityID, Zip, Phone, Email)
    VALUES (@FirstName, @LastName, @Address, @CityID, @Zip, @Phone, @Email);

    -- Pobieranie ID nowo dodanego studenta

    SET @ReturnID = SCOPE_IDENTITY();

    PRINT 'Student został pomyślnie dodany.';
END;

CREATE PROCEDURE dbo.dodaj_studia

    @StudyName VARCHAR(50),
    @StudyDescription TEXT,
	@StudyPrice MONEY,
	@StudyCoordinator INT,
	@PriceIncrease MONEY
AS
BEGIN
    SET NOCOUNT ON;

    -- Dodawanie studia
    INSERT INTO Studies(StudyName, StudyDescription, StudyPrice, StudyCoordinator, PriceIncrease)
    VALUES (@StudyName, @StudyDescription, @StudyPrice, @StudyCoordinator, @PriceIncrease);

    -- Pobieranie ID nowo dodanych studiów
    DECLARE @StudyID INT = SCOPE_IDENTITY();

    PRINT 'Studia zostały pomyślnie dodane.';
END;