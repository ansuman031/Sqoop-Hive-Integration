#-------------------sqoop hive integration usecase-------------------------#

	
	echo "execution started";

	if [ $(mysql -uroot -proot  -hlocalhost usecase -sse \
	 "select count(*) from usecase.T1;") -gt 0 ]; then
	echo "table exist"

	else
	echo "table doesnt exist"
	exit 0;
	fi
#------------sqoop execution starts------------------------------------------#
	echo "sqoop  import execution starts"

sqoop import --connect jdbc:mysql://localhost/usecase --username root --password root -table T1 -m 1 --target-dir sqoop_practice_import -delete-target-dir;

		last_command=$?

			if [ $last_command -ne 0 ]; then

			echo "import not sucessfull"
			exit 0;
l
			else 
			echo "import sucessfull";
			fi

		echo "checking sqoop directory exist or not "

 		hadoop fs -test -d /user/hduser/sqoop_import_script;
		last_command=$?
	

		if [ $last_command -eq 0 ]; then 

		echo "sqoop export execution starts"

sqoop export --connect jdbc:mysql://localhost/usecase --username root --password root --table T2 --export-dir sqoop_practice_import;

		last_command=$?

			if [ $last_command -ne 0 ];then
			echo "export not sucessfull"
			exit 0;

			else
			echo "export sucessfull"

			fi
#-----------------------------------------------------sqoop execution ends----------------------------------------------#
#-------------------------------------------------------------hive------------------------------------------------------#

#-------------------hive execution started---------------------------#
		echo "hive execution started"

		hadoop fs -mkdir /user/hduser/hive_sqoop;
		
		hadoop fs -cp /user/hduser/sqoop_practice_import /user/hduser/hive_sqoop;

		echo "running hive queries"

		hive -f db.sql;

		last_command=$?
					if [ $last_command -ne 0 ];then
						echo "hive query 1 did not ran"
						exit 0;		
						else
						echo "hive query 1 ran sucessfully"
		
						echo "executing hive sql 2 queries"
					fi
						hive -f ext_tbl.sql;

					if [ $last_command -ne 0 ];then
						echo "hive query 2 did not ran"
						exit 0;
	
						else
						echo "hive query 2 ran sucessfully"
					fi
						hive -f int_tbl.sql;

					if [ $last_command -ne 0 ];then
						echo "hive query 3 did not ran"
						exit 0;

						else
						echo "hive query 3 ran sucessfully"
					fi
		
#----------------------hive execution ended-------------------------------------------------#

		else "sqoop direcoty doesnt exist"
		exit 0;
		fi
		echo "Script execution completed "
