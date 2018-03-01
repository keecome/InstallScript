# from https://github.com/it-projects-llc/odoo-saas-tools
# Make a new file:
# sudo nano clone-saas.sh
# Place this content in it and then make the file executable:
# sudo chmod +x clone-saas.sh
# Execute the script to install Odoo:
# ./clone-saas.sh

#odoo config
##fixed parameters
#odoo
OE_USER="odoo"
OE_HOME="/data/$OE_USER"
OE_HOME_EXT="/data/$OE_USER/${OE_USER}-server"
#The default port where this Odoo instance will run under (provided you use the command -c in the terminal)
#Set to true if you want to install it, false if you don't need it or have it already installed.
INSTALL_WKHTMLTOPDF="True"
CLONE_ODOO="yes"
#Set the default Odoo port (you still have to use -c /etc/odoo-server.conf for example to use this.)
OE_PORT="8069"
#Choose the Odoo version which you want to install. For example: 11.0, 10.0, 9.0 or saas-18. When using 'master' the master version will be installed.
#IMPORTANT! This script contains extra libraries that are specifically needed for Odoo 11.0
OE_VERSION="11.0"
# Set this to True if you want to install Odoo 11 Enterprise!
IS_ENTERPRISE="False"
#set the superadmin password
OE_SUPERADMIN="admin"
OE_CONFIG="${OE_USER}-server"

ADDONS_DIR="${OE_HOME}/custom"

CLONE_OCA="yes"
CLONE_IT_PROJECTS_LLC="yes"
UPDATE_ADDONS_PATH="no"

echo -e "\n---- Clone OCA & it-projects-llc Model ----"
cd $OE_HOME
mkdir -p $ADDONS_DIR
cd $ADDONS_DIR
REPOS=()
 #Hint: REPOS=( "${REPOS[@]}" "new element") - is way to add element to array

 if [[ "$CLONE_OCA" == "yes" ]]
 then
     REPOS=( "${REPOS[@]}" "https://github.com/OCA/web.git OCA/web")
     REPOS=( "${REPOS[@]}" "https://github.com/OCA/event.git OCA/event")
     REPOS=( "${REPOS[@]}" "https://github.com/OCA/website.git OCA/website")
     REPOS=( "${REPOS[@]}" "https://github.com/OCA/account-financial-reporting.git OCA/account-financial-reporting")
     REPOS=( "${REPOS[@]}" "https://github.com/OCA/account-financial-tools.git OCA/account-financial-tools")
     REPOS=( "${REPOS[@]}" "https://github.com/OCA/partner-contact.git OCA/partner-contact")
     REPOS=( "${REPOS[@]}" "https://github.com/OCA/hr.git OCA/hr")
     REPOS=( "${REPOS[@]}" "https://github.com/OCA/pos.git OCA/pos")
     REPOS=( "${REPOS[@]}" "https://github.com/OCA/commission.git OCA/commission")
     REPOS=( "${REPOS[@]}" "https://github.com/OCA/server-tools.git OCA/server-tools")
     REPOS=( "${REPOS[@]}" "https://github.com/OCA/reporting-engine.git OCA/reporting-engine")
     REPOS=( "${REPOS[@]}" "https://github.com/OCA/rma.git OCA/rma")
     REPOS=( "${REPOS[@]}" "https://github.com/OCA/contract.git OCA/contract")
     REPOS=( "${REPOS[@]}" "https://github.com/OCA/sale-workflow.git OCA/sale-workflow")
     REPOS=( "${REPOS[@]}" "https://github.com/OCA/bank-payment.git OCA/bank-payment")
     REPOS=( "${REPOS[@]}" "https://github.com/OCA/bank-statement-import.git OCA/bank-statement-import")
     REPOS=( "${REPOS[@]}" "https://github.com/OCA/bank-statement-reconcile.git OCA/bank-statement-reconcile")
     REPOS=( "${REPOS[@]}" " https://github.com/OCA/product-attribute.git OCA/product-attribute")
 fi

 if [[ "$CLONE_IT_PROJECTS_LLC" == "yes" ]]
 then
     REPOS=( "${REPOS[@]}" "https://github.com/it-projects-llc/e-commerce.git it-projects-llc/e-commerce")
     REPOS=( "${REPOS[@]}" "https://github.com/it-projects-llc/pos-addons.git it-projects-llc/pos-addons")
     REPOS=( "${REPOS[@]}" "https://github.com/it-projects-llc/access-addons.git it-projects-llc/access-addons")
     REPOS=( "${REPOS[@]}" "https://github.com/it-projects-llc/website-addons.git it-projects-llc/website-addons")
     REPOS=( "${REPOS[@]}" "https://github.com/it-projects-llc/misc-addons.git it-projects-llc/misc-addons")
     REPOS=( "${REPOS[@]}" "https://github.com/it-projects-llc/mail-addons.git it-projects-llc/mail-addons")
     REPOS=( "${REPOS[@]}" "https://github.com/keecome/odoo-saas-tools.git it-projects-llc/odoo-saas-tools")
     REPOS=( "${REPOS[@]}" "https://github.com/it-projects-llc/odoo-telegram.git it-projects-llc/odoo-telegram")
 fi

 if [[ "${REPOS}" != "" ]]
 then
     apt-get install -y git
 fi

 for r in "${REPOS[@]}"
 do
     eval "git clone --depth=1 -b ${OE_VERSION} $r" || echo "Cannot clone: git clone -b ${OE_VERSION} $r"
 done

 if [[ "${REPOS}" != "" ]]
 then
     chown -R ${ODOO_USER}:${ODOO_USER} $ADDONS_DIR || true
 fi


 if [[ "$UPDATE_ADDONS_PATH" == "yes" ]]
 then
     # $ADDONS_DIR:
     #
     # it-projects-llc/
     #  -> pos-addons/
     #  -> ...
     # OCA/
     #  -> pos/
     #  -> ...
     ADDONS_PATH=`ls -d1 $OE_HOME/custom/*/* | tr '\n' ','`
     ADDONS_PATH=`echo $OE_HOME_EXT/odoo/addons,$OE_HOME_EXT/addons,$ADDONS_PATH | sed "s,//,/,g" | sed "s,/,\\\\\/,g" | sed "s,.$,,g" `
    # sed -ibak "s/addons_path.*/addons_path = $ADDONS_PATH/" /etc/${OE_CONFIG}.conf

 fi

#--------------------------------------------------
# Install Dependencies
#--------------------------------------------------
#cd 
#pip install -r requirements.txt

#### Changes on Odoo Code
#cd $ODOO_SOURCE_DIR
## delete matches="..." at /web/database/manager
echo -e "\n---- setup base.xml ----"
 sed -i 's/matches="[^"]*"//g' $OE_HOME_EXT/addons/web/static/src/xml/base.xml

