unit SQLhandler;

interface

uses
  Windows, Classes, Dialogs, SysUtils, Forms, MudUtil, Grobal2, ActiveX,
  DB, DBAccess, MSAccess, MemDS, MemData;

const
  SQLTYPE_SELECT            = 1;
  SQLTYPE_SELECTWHERE       = 2;
  SQLTYPE_UPDATE            = 3;
  SQLTYPE_INSERT            = 4;
  SQLTYPE_DELETE            = 5;
  SQLTYPE_SELECTWHERENOT    = 6;
  SQLTYPE_DELETENOT         = 7;

  TABLETYPE_STR             = 1;
  TABLETYPE_INT             = 2;
  TABLETYPE_DAT             = 3;
  TABLETYPE_DBL             = 4;

type
  tagMIRDB_FIELDS = packed record
    szFieldName: string[30];
    btType: Byte;
    fIsKey: Boolean;
    nSize: Integer;
  end;
  MIRDB_FIELDS = tagMIRDB_FIELDS;
  LPMIRDB_FIELDS = ^tagMIRDB_FIELDS;

  tagMIRDB_TABLE = packed record
    szTableName: string[30];
    nNumOfFields: Integer;
    lpFields: LPMIRDB_FIELDS;
  end;
  MIRDB_TABLE = tagMIRDB_TABLE;
  LPMIRDB_TABLE = ^tagMIRDB_TABLE;

function _MakeSQLParam(var pszSQL: string; nSQLType:Integer; lpTable: LPMIRDB_TABLE; const Args: array of const): Boolean;
function _MakeSQL(var pszSQL: string; nSQLType : Integer;  lpTable : LPMIRDB_TABLE; pData: PChar): Boolean;
//procedure _GetFields(CRecordset * pRec, lpTable LPMIRDB_TABLE; pData: PChar);

implementation

//bool _makesqlparam(char *pszSQL, int nSQLType, LPMIRDB_TABLE lpTable, ...)
function _MakeSQLParam(var pszSQL: string; nSQLType:Integer; lpTable: LPMIRDB_TABLE; const Args: array of const): Boolean;
begin
	va_list		v;
	int			nCnt = 0, nCnt2 = 0;
	char		szTemp[256];

	switch (nSQLType)
	{
		case SQLTYPE_SELECT:
			sprintf(pszSQL, "SELECT * FROM %s", lpTable->szTableName);
			return true;
		case SQLTYPE_SELECTWHERE:
		{
			sprintf(pszSQL, "SELECT * FROM %s WHERE ", lpTable->szTableName);
			
			va_start(v, lpTable);

			for (int i = 0; i < lpTable->nNumOfFields; i++)
			{
				if (lpTable->lpFields[i].fIsKey)
				{
					if (nCnt >= 1)
						strcat(pszSQL, "AND ");

					if (lpTable->lpFields[i].btType == TABLETYPE_STR)
						sprintf(szTemp, "%s='%s' ", lpTable->lpFields[i].szFieldName, va_arg(v, char *));
					else
						sprintf(szTemp, "%s=%d ", lpTable->lpFields[i].szFieldName, va_arg(v, int));

					strcat(pszSQL, szTemp);
					nCnt++;
				}
			}
		
			va_end(v);

			return true;
		}
		case SQLTYPE_SELECTWHERENOT: // TO PDS
		{
			sprintf(pszSQL, "SELECT * FROM %s WHERE ", lpTable->szTableName);
			
			va_start(v, lpTable);

			for (int i = 0; i < lpTable->nNumOfFields; i++)
			{
				if (lpTable->lpFields[i].fIsKey)
				{
					if (nCnt >= 1)
						strcat(pszSQL, "AND ");
					
					if ( nCnt )
					{
						if (lpTable->lpFields[i].btType == TABLETYPE_STR)
							sprintf(szTemp, "%s<>'%s' ", lpTable->lpFields[i].szFieldName, va_arg(v, char *));
						else
							sprintf(szTemp, "%s<>%d ", lpTable->lpFields[i].szFieldName, va_arg(v, int));
					}
					else
					{
						if (lpTable->lpFields[i].btType == TABLETYPE_STR)
							sprintf(szTemp, "%s='%s' ", lpTable->lpFields[i].szFieldName, va_arg(v, char *));
						else
							sprintf(szTemp, "%s=%d ", lpTable->lpFields[i].szFieldName, va_arg(v, int));
			
					}

					strcat(pszSQL, szTemp);
					nCnt++;
				}
			}
		
			va_end(v);

			return true;
		}
		case SQLTYPE_UPDATE:
		{
			char	szWhere[128];
			char	szWhereFull[512];

			sprintf(pszSQL, "UPDATE %s SET ", lpTable->szTableName);
			
			strcpy(szWhereFull, "WHERE ");			
			
			va_start(v, lpTable);

			for (int i = 0; i < lpTable->nNumOfFields; i++)
			{
				if (lpTable->lpFields[i].fIsKey)
				{
					if (nCnt >= 1)
						strcat(szWhereFull, "AND ");

					if (lpTable->lpFields[i].btType == TABLETYPE_STR)
						sprintf(szWhere, "%s='%s' ", lpTable->lpFields[i].szFieldName, va_arg(v, char *));
					else
						sprintf(szWhere, "%s=%d ", lpTable->lpFields[i].szFieldName, va_arg(v, int));

					strcat(szWhereFull, szWhere);
					nCnt++;
				}
				else
				{
					if (nCnt2 >= 1)
						strcat(szTemp, ", ");

					if (lpTable->lpFields[i].btType == TABLETYPE_STR)
						sprintf(szTemp, "%s='%s'", lpTable->lpFields[i].szFieldName, va_arg(v, char *));
					else if (lpTable->lpFields[i].btType == TABLETYPE_DAT)
						sprintf(szWhere, "%s=GETDATE()", lpTable->lpFields[i].szFieldName);
					else
						sprintf(szTemp, "%s=%d", lpTable->lpFields[i].szFieldName, va_arg(v, int));

					strcat(pszSQL, szTemp);
					nCnt++;
				}
			}

			va_end(v);

			strcat(pszSQL, szWhereFull);

			return true;
		}
		case SQLTYPE_INSERT:
		{
			sprintf(pszSQL, "INSERT %s (", lpTable->szTableName);

			for (int i = 0; i < lpTable->nNumOfFields; i++)
			{
				strcat(pszSQL, lpTable->lpFields[i].szFieldName);

				if (i + 1 != lpTable->nNumOfFields)
					strcat(pszSQL, ", ");
				else
					strcat(pszSQL, ") ");
			}

			strcat(pszSQL, "VALUES (");

			va_start(v, lpTable);

			for (i = 0; i < lpTable->nNumOfFields; i++)
			{
				if (lpTable->lpFields[i].btType == TABLETYPE_STR)
					sprintf(szTemp, "'%s'", va_arg(v, char *));
				else if (lpTable->lpFields[i].btType == TABLETYPE_DAT)
					sprintf(szTemp, "GETDATE()");
				else
					sprintf(szTemp, "%d", va_arg(v, int));

				strcat(pszSQL, szTemp);

				if (i + 1 != lpTable->nNumOfFields)
					strcat(pszSQL, ", ");
				else
					strcat(pszSQL, ")");
			}

			va_end(v);

			return true;
		}
		case SQLTYPE_DELETE:
		{
			sprintf(pszSQL, "DELETE FROM %s WHERE ", lpTable->szTableName);

			va_start(v, lpTable);

			for (int i = 0; i < lpTable->nNumOfFields; i++)
			{
				if (lpTable->lpFields[i].fIsKey)
				{
					if (nCnt >= 1)
						strcat(pszSQL, "AND ");

					if (lpTable->lpFields[i].btType == TABLETYPE_STR)
						sprintf(szTemp, "%s='%s' ", lpTable->lpFields[i].szFieldName, va_arg(v, char *));
					else
						sprintf(szTemp, "%s=%d ", lpTable->lpFields[i].szFieldName, va_arg(v, int));

					strcat(pszSQL, szTemp);

					nCnt++;
				}
			}

			va_end(v);

			return true;
		}
		case SQLTYPE_DELETENOT:
		{
			sprintf(pszSQL, "DELETE FROM %s WHERE ", lpTable->szTableName);

			va_start(v, lpTable);

			for (int i = 0; i < lpTable->nNumOfFields; i++)
			{
				if (lpTable->lpFields[i].fIsKey)
				{
					if (nCnt >= 1)
						strcat(pszSQL, "AND ");

					if ( nCnt )
					{
						if (lpTable->lpFields[i].btType == TABLETYPE_STR)
							sprintf(szTemp, "%s<>'%s' ", lpTable->lpFields[i].szFieldName, va_arg(v, char *));
						else
							sprintf(szTemp, "%s<>%d ", lpTable->lpFields[i].szFieldName, va_arg(v, int));
					}
					else
					{
						if (lpTable->lpFields[i].btType == TABLETYPE_STR)
							sprintf(szTemp, "%s='%s' ", lpTable->lpFields[i].szFieldName, va_arg(v, char *));
						else
							sprintf(szTemp, "%s=%d ", lpTable->lpFields[i].szFieldName, va_arg(v, int));
					}

					strcat(pszSQL, szTemp);

					nCnt++;
				}
			}

			va_end(v);

			return true;
		}
	}

	return false;
end;

end.

