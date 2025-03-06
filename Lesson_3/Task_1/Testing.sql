BEGIN TRANSACTION;

INSERT INTO [User] (Name, SecondName) VALUES 
('Vadim', 'Chepil');
('Alexei','Sydorenko'),
('Alexander', 'Petrenko'),
('Mary', 'Ivanenko');


INSERT INTO Category (Description) VALUES 
('Technology'),
('Education'),
('Art');


INSERT INTO Project (Name, Description, CreatorId, CategoryId) VALUES 
('Smart Home', 'Home Automation', 1, 1),
('Online Courses', 'Educational Platform', 2, 2),
('Digital Gallery', 'Virtual Art Exhibition', 3, 3);


INSERT INTO Comment (Text, UserId, ProjectId) VALUES 
('Great idea!', 2, 1),
('Very useful project!', 3, 2),
('I would like to see more details.', 1, 3);


INSERT INTO Vote (UserId, ProjectId) VALUES 
(2, 1),
(3, 1),
(1, 2),
(3, 2),
(1, 3);


COMMIT TRANSACTION;

SELECT * FROM [User];

SELECT * FROM Category;

SELECT * FROM Comment;

SELECT * FROM Project;

SELECT * FROM Vote;

EXEC CreateProject 'Eco-farm of the future', 'Automated solar farm', 1, 1;

EXEC CreateComment 'Great initiative!', 2, 4; 

EXEC GetProjectInfo 1;

EXEC GetProjectsPaginated @PageNumber = 1, @PageSize = 2, @CategoryId = NULL, @StartDate = NULL, @EndDate = NULL;

EXEC AddVote 4, 2; 