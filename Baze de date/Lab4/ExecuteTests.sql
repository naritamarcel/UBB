USE Chess
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create or alter PROCEDURE [dbo].[executeTests]
AS
BEGIN

	DECLARE Cursor_principal CURSOR FOR
	SELECT T.TestID, T.Name
	FROM Tests T
	OPEN Cursor_principal

	DECLARE @id_test int, @nume varchar(100)
	DECLARE @durata_test_principal time

	FETCH NEXT FROM Cursor_principal into @id_test, @nume
		while @@FETCH_STATUS = 0
		begin
			DECLARE @nume_tabela varchar(50)

			--cursor DELETE
					DECLARE Cursor_delete CURSOR FOR
							SELECT Name
							FROM Tables T, TestTables TT
							WHERE TT.TableID = T.TableID AND T.TableID in
										 (select TT.TableID
											from TestTables TT
											where TT.TestID = @id_test
										) 
							ORDER BY TT.Position desc

							OPEN Cursor_delete

							FETCH NEXT FROM Cursor_delete into @nume_tabela
									while @@FETCH_STATUS = 0
									begin

										exec dbo.deleteData 8,3,@nume_tabela
										--exec dbo.deleteData 8, 5, @nume_tabela

										fetch next from Cursor_delete into @nume_tabela
									end
							
						CLOSE Cursor_delete
						DEALLOCATE Cursor_delete

			set @durata_test_principal = GETDATE()
		
			insert into TestRuns(Description, StartAt) values('descriere test', @durata_test_principal)


			--cursor INSERT
				DECLARE @durata_insert time
				DECLARE Cursor_insert CURSOR FOR
				SELECT T.Name, TT.NoOfRows, T.TableID
				FROM Tables T, TestTables TT
				WHERE  TT.TestID = @id_test and TT.TableID = T.TableID 
				ORDER BY TT.Position asc

							OPEN Cursor_insert

							DECLARE @cod_tabel int
							DECLARE @nr_randuri int;

							FETCH NEXT FROM Cursor_insert into @nume_tabela, @nr_randuri, @cod_tabel
									while @@FETCH_STATUS = 0
										begin
											set @durata_insert = GETDATE()
											exec insertTestTableData @id_test, @cod_tabel, @durata_insert
											
											--exec insertData 8,@nr_randuri, @nume_tabela Am folosit doar 3 pentru testare, dar merge si cu @nr_randuri
											exec insertData 8, 3, @nume_tabela
											set @durata_insert = GETDATE()
											exec updateTestData @durata_insert
											fetch next from Cursor_insert into @nume_tabela, @nr_randuri, @cod_tabel
										end
						CLOSE Cursor_insert
						DEALLOCATE Cursor_insert
				
				--cursor SELECT
					DECLARE @durata_select time
					DECLARE @nume_view varchar(50)
					DECLARE @id_view int

					DECLARE Cursor_select CURSOR FOR
					SELECT V.Name, V.ViewID
					FROM Views V, TestViews TV
					WHERE  TV.TestID = @id_test and TV.ViewID = V.ViewID 

					OPEN Cursor_select
							FETCH NEXT FROM Cursor_select into @nume_view, @id_view
									while @@FETCH_STATUS = 0
									begin
										set @durata_select = GETDATE()
										exec insertTestViewData @id_test, @id_view, @durata_select

										exec dbo.executaView @nume_view

										set @durata_select = GETDATE()
										exec updateTestData @durata_select
										fetch next from Cursor_select into @nume_view, @id_view
									end
						CLOSE Cursor_select
						DEALLOCATE Cursor_select
			
				--next test
				set @durata_test_principal = GETDATE();
				exec updateTestData @durata_test_principal
				fetch next from Cursor_principal into @id_test, @nume
		end
	
	CLOSE Cursor_principal
	DEALLOCATE Cursor_principal
END

--exec insertData 8,5,'Player_Rating'
--exec deleteData 8,5,'Player_Rating'

--Run this!
use Chess
exec executeTests
select * from TestRuns
------
	exec insertData 8,3,'Player_Rating'
	exec insertData 8,3,'Players'
	exec insertData 8,3,'Rankings'

	exec deleteData 8,3,'Rankings'
	exec deleteData 8,3,'Players'
	exec deleteData 8,3,'Player_Rating'

	select * from Players