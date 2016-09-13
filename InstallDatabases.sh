#!/bin/sh
##############################################################################
# This utility assist you in setting up your mangos database.				 #
# This is a port of InstallDatabases.bat written by Antz for Windows		 #
#																			 #
##############################################################################

RELEASE="Rel21"
UPDATES="Rel20_to_BaseRel21_Updates"
DUMP="NO"

createcharDB="YES"
createworldDB="YES"
createrealmDB="YES"

loadcharDB="YES"
loadworldDB="YES"
loadrealmDB="YES"
dbType="POPULATED"

updatecharDB="NO"
updateworldDB="NO"
updaterealmDB="NO"

addRealmList="YES"

svr_def="localhost"
user_def="mangos"
pass_def=""
port_def="3306"
wdb_def="mangos0"
cdb_def="character0"
rdb_def="realmd"

printHelp()
{
	printf "Usage: $0 [-s] [-u] [-d] [-h]\n"
	printf "\t-s: Run this script in silent mode, only prompt for the database information\n"
	printf "\t-u: Run only the updates of the database\n"
	printf "\t-d: Dump the database configuration into the home directory of the user\n"
	printf "\t-h: Display this help\n"
}

printBanner()
{
	clear
	printf " #     #     #    #   #  ###   ###   ####  \n"
	printf " ##   ##    # #   ##  # #     #   # #      \n"
	printf " # # # #   #   #  # # # # ### #   #  ###   \n"
	printf " #  #  #  ####### #  ## #   # #   #     #  \n"
	printf " #     #  #     # #   #  ###   ###  ####   \n"
	printf "\n"
	printf " Database Setup and World Loader v0.01 	\n"
	printf " ---------------------------------------------- \n"
	printf "  Website / Forum / Wiki : https://getmangos.eu \n"
	printf " ---------------------------------------------- \n"
	printf "\n"
	printf "\n"
}

printActivities()
{
	printf "\tCharacter Database : \tV - Toggle Create DB (${createcharDB})	\n"
	printf "\t\t\t\tC - Toggle Create Structure (${loadcharDB}) \n"
	printf "\t\t\t\tB - Apply Character DB updates (${updatecharDB})\n"
	printf "\n"
	printf "\t    World Database : \tE - Toggle Create DB (${createworldDB}) \n"
	printf "\t\t\t\tW - Toggle Create Structure (${loadworldDB}) \n"	
	if [ "${loadworldDB}" = "YES" ]; then
		printf "\t\t\t\tD - Toggle World Type (${dbType})\n"
	fi
	printf "\t\t\t\tU - Apply World DB updates (${updateworldDB})\n"
	printf "\n"
	printf "\t    Realm Database : \tT - Toggle Create DB (${createrealmDB})\n"
	printf "\t\t\t\tR - Toggle Create Structure (${loadrealmDB})\n"
	printf "\t\t\t\tY - Apply Realm DB updates (${updaterealmDB})\n"
	printf "\t\t\t\tL - Toggle Add RealmList Entry (${addRealmList})\n"	
	printf "\n"
	printf "\t\t\t\tN - Next Step\n"
	printf "\t\t\t\tX - Exit\n"
}

createCharDB()
{
	printf "Creating Character database ${cdb}\n"
	mysql --login-path=local -q -s -e "Create database ${cdb}"
	if [ "${loadcharDB}" = "YES" ]; then
		loadCharDB
	fi
}

loadCharDB()
{
	printf "Loading data into character database ${cdb}\n"
	mysql --login-path=local -q -s ${cdb} < Character/Setup/characterLoadDB.sql
}

updateCharDB()
{
	printf "Updating data into the character database ${cdb}\n"
	for file in $(ls Character/Updates/${RELEASE}/${UPDATES}/*.sql | tr ' ' '|' | tr '\n' ' ')
	do
		file=$(echo ${file} | tr '|' ' ')
		printf "Applying update ${file}\n"
		mysql --login-path=local -q -s ${cdb} < ${file}
	done
}

createWorldDB()
{
	printf "Creating World database ${wdb}\n"
	mysql --login-path=local -q -s -e "Create database ${wdb}"
	if [ "${loadworldDB}" = "YES" ]; then
		loadWorldDB
	fi
}

loadWorldDB()
{
	printf "Loading data into world database ${wdb}\n"
	mysql --login-path=local -q -s ${wdb} < World/Setup/mangosdLoadDB.sql
	
	if [ "${dbType}" = "POPULATED" ]; then
		populateWorldDB
	fi
}

populateWorldDB()
{
	printf "Importing World database ${wdb}\n"
	for file in $(ls World/Setup/FullDB/*.sql | tr ' ' '|' | tr '\n' ' ') 
	do
		file=$(echo ${file} | tr '|' ' ')
		printf "Importing file ${file}\n"
		mysql --login-path=local -q -s ${wdb} < ${file}
		printf "File ${file} imported\n"
	done
}

updateWorldDB()
{
	printf "Updating data into the World database ${wdb}\n"
	for file in $(ls World/Updates/${RELEASE}/${UPDATES}/*.sql | tr ' ' '|' | tr '\n' ' ')
	do
		file=$(echo ${file} | tr '|' ' ')
		printf "Applying update ${file}\n"
		mysql --login-path=local -q -s ${wdb} < ${file}
	done
}

createRealmDB()
{
	printf "Creating realm database ${rdb}\n"
	mysql --login-path=local -q -s -e "Create database ${rdb}"
	if [ "${loadrealmDB}" = "YES" ]; then
		loadRealmDB
	fi
}

loadRealmDB()
{
	printf "Loading data into realm database ${rdb}\n"	
	mysql --login-path=local -q -s ${rdb} < Realm/Setup/realmdLoadDB.sql
}

updateRealmDB()
{
	printf "Updating data into the Realm database ${rdb}\n"
	for file in $(ls Realm/Updates/${RELEASE}/${UPDATES}/*.sql | tr ' ' '|' | tr '\n' ' ')
	do
		file=$(echo ${file} | tr '|' ' ')
		printf "Applying update ${file}\n"
		mysql --login-path=local -q -s ${wdb} < ${file}
	done
}

addRealmList()
{
	printf "Adding realm list entries\n"
	mysql --login-path=local -q -s ${rdb} < Tools/updateRealm.sql
}

activity=""

while getopts "suh" o; do
	case "${o}" in
		s)
			activity="N"
			printf "You selected silent mode\n"
			;;
		u)
			createcharDB="NO"
			createworldDB="NO"
			createrealmDB="NO"

			loadcharDB="NO"
			loadworldDB="NO"
			loadrealmDB="NO"
			dbType="EMPTY"
			printf "You selected update only\n"
			;;
		d)
			DUMP="YES"
			;;
		h)
			printHelp
			exit 0
			;;
	esac
done

while [ -z "${activity}" ] || [ "${activity}" != "N" ]
do
	printBanner
	printActivities
	printf "Please select an activity : "
	read activity
	case ${activity} in
		"V")
			if [ "${createcharDB}" = "YES" ]; then
				createcharDB="NO"
			else 
				createcharDB="YES"
			fi
			;;
		"C")
			if [ "${loadcharDB}" = "YES" ]; then
				loadcharDB="NO"
			else 
				loadcharDB="YES"
			fi
			;;
		"B")
			if [ "${updatecharDB}" = "YES" ]; then
				updatecharDB="NO"
			else 
				updatecharDB="YES"
			fi
			;;
		"E")
			if [ "${createworldDB}" = "YES" ]; then
				createworldDB="NO"
			else 
				createworldDB="YES"
			fi	
			;;
		"W")
			if [ "${loadworldDB}" = "YES" ]; then
				loadworldDB="NO"
			else 
				loadworldDB="YES"
			fi	
			;;
		"D")
			if [ "${dbType}" = "POPULATED" ]; then
				dbType="EMPTY"
			else 
				dbType="POPULATED"
			fi 				
			;;
		"U")
			if [ "${updateworldDB}" = "YES" ]; then
				updateworldDB="NO"
			else 
				updateworldDB="YES"
			fi
			;;
		"T")
			if [ "${createrealmDB}" = "YES" ]; then
				createrealmDB="NO"
			else 
				createrealmDB="YES"
			fi 				
			;;
		"R")
			if [ "${loadrealmDB}" = "YES" ]; then
				loadrealmDB="NO"			
			else 
				loadrealmDB="YES"
			fi
			;;
		"Y")
			if [ "${updaterealmDB}" = "YES" ]; then
				updaterealmDB="NO"
			else 
				updaterealmDB="YES"
			fi
			;;
		"L")
			if [ "${addRealmList}" = "YES" ]; then
				addRealmList="NO"
			else 
				addRealmList="YES"
			fi
			;;
		"X")
			exit 0;;
		*)
			printf "Invalid selection";;
	esac
done

printBanner
printf "What is your MySQL host name ?\t[${svr_def}]: "
read svr
svr=${svr:-${svr_def}}
printf "What is your MySQL user name ?\t[${user_def}]: "
read user
user=${user:-${user_def}}
printf "What is your MySQL port ?\t[${port_def}]: "
read port
port=${port:-${port_def}}
printf "What is your MySQL password ?\t [], "
mysql_config_editor set --login-path=local --host=${svr} --port=${port} --user=${user} --password --skip-warn
if [ "${DUMP}" = "YES" ]; then
	printf "Enter it again \t[]: "
	read pass
fi
printf "What is your Character database name ?\t[${cdb_def}]: "
read cdb
cdb=${cdb:-${cdb_def}}
printf "What is your World database name ?\t[${wdb_def}]: "
read wdb
wdb=${wdb:-${wdb_def}}
printf "What is your Realm database name ?\t[${rdb_def}]: "
read rdb
rdb=${rdb:-${rdb_def}}

if [ "${createcharDB}" = "YES" ]; then
	createCharDB
fi

if [ "${createworldDB}" = "YES" ]; then
	createWorldDB
fi

if [ "${createrealmDB}" = "YES" ]; then
	createRealmDB
fi

if [ "${updatecharDB}" = "YES" ]; then
	updateCharDB
fi

if [ "${updateworldDB}" = "YES" ]; then
	updateWorldDB
fi

if [ "${updaterealmDB}" = "YES" ]; then
	updateRealmDB
fi

if [ "${addRealmList}" = "YES" ]; then
	addRealmList
fi

if [ "${DUMP}" = "YES" ]; then
	printf "Dumping database information...\n"
	echo "${svr};${port};${user};${pass};${rdb}" > ~/db.conf
	echo "${svr};${port};${user};${pass};${wdb}" >> ~/db.conf
	echo "${svr};${port};${user};${pass};${cdb}" >> ~/db.conf
fi

printBanner
printf "Database creation and load complete :-)\n"
printf "\n"
