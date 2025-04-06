-- Create a trigger to log course orders
CREATE TRIGGER trg_LogCourseOrder
ON OrderCourses
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Insert log entries for newly added course orders
    INSERT INTO CourseOrderLog (OrderDetailsID, CourseID, BuyPrice)
    SELECT i.OrderDetailsID, i.CourseID, i.BuyPrice
    FROM inserted i;
END;