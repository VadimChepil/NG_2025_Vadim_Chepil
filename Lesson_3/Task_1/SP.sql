CREATE PROCEDURE CreateProject 
	@Name NVARCHAR(100),
	@Description NVARCHAR(255),
	@CreatorId INT,
	@CategoryId INT
AS
BEGIN
	INSERT INTO Project (Name, Description, CreatorId, CategoryId)
	VALUES (@Name, @Description, @CreatorId, @CategoryId);
END;

GO

CREATE PROCEDURE CreateComment
	@Text NVARCHAR(255),
	@UserId INT,
	@ProjectId INT
AS
BEGIN
	INSERT INTO Comment (Text, UserId, ProjectId)
	VALUES (@Text, @UserId, @ProjectId)
END;

GO

CREATE PROCEDURE GetProjectInfo
	@ProjectId INT
AS
BEGIN
	SELECT p.Id, p.Name, p.Description, p.CreationDate, c.Description AS Category, u.Name + ' ' + u.SecondName AS Creator,
           (SELECT COUNT(*) FROM Vote v WHERE v.ProjectId = p.Id) AS Votes
    FROM Project p
    JOIN Category c ON p.CategoryId = c.Id
    JOIN [User] u ON p.CreatorId = u.Id
    WHERE p.Id = @ProjectId;

	 SELECT Text, Date, UserId FROM Comment WHERE ProjectId = @ProjectId ORDER BY Date DESC;
END;

GO

CREATE PROCEDURE GetProjectsPaginated
    @PageNumber INT,
    @PageSize INT,
    @CategoryId INT = NULL,
    @StartDate DATETIME = NULL,
    @EndDate DATETIME = NULL
AS
BEGIN
    SELECT * FROM (
        SELECT p.Id, p.Name, c.Description AS Category, p.CreationDate,
               ROW_NUMBER() OVER (ORDER BY p.CreationDate DESC) AS RowNum
        FROM Project p
        JOIN Category c ON p.CategoryId = c.Id
        WHERE (@CategoryId IS NULL OR p.CategoryId = @CategoryId)
          AND (@StartDate IS NULL OR p.CreationDate >= @StartDate)
          AND (@EndDate IS NULL OR p.CreationDate <= @EndDate)
    ) AS ProjectsWithRowNum
    WHERE RowNum BETWEEN (@PageNumber - 1) * @PageSize + 1 AND @PageNumber * @PageSize;
END;

GO

CREATE PROCEDURE AddVote
    @ProjectId INT,
    @UserId INT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Vote WHERE ProjectId = @ProjectId AND UserId = @UserId)
    BEGIN
        INSERT INTO Vote (ProjectId, UserId) VALUES (@ProjectId, @UserId);
    END;
END;

