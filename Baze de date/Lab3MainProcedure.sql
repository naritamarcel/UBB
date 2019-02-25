use Chess;
exec getDatabaseToVersion  5;

go
Create PROCEDURE getDatabaseToVersion
	@versionTo int
AS
BEGIN
	DECLARE @versionFrom int

	SET @versionFrom = (select V.current_version
							from Database_Version V)

	DECLARE @query varchar(2000)

	IF @versionTo <= 7 AND @versionTo >=0
	BEGIN
		IF @versionTo > @versionFrom
		BEGIN
			 WHILE @versionTo>@versionFrom
				BEGIN
					set @versionFrom = @versionFrom + 1
					set @query = 'up' + CAST(@versionFrom AS VARCHAR(5))
					exec @query
				END
		END
		---------------------------
		ELSE  
		BEGIN 
			WHILE @versionTo<@versionFrom
				BEGIN
					IF @versionFrom!=0
					BEGIN
						set @query = 'down' + CAST(@versionFrom AS VARCHAR(5))
						exec @query
					END
					set @versionFrom = @versionFrom - 1
				END
		END
		update Database_Version 
		set current_version = @versionTo
		Print 'The new version is : ' +CAST(@versionTo AS VARCHAR(5))
		END

		ELSE

		BEGIN
		PRINT 'Give a number between 0 and 7!!! '
		END
END
go




