global function InitPromoData
global function UpdatePromoData
global function TEMP_UpdatePromoData
global function IsPromoDataProtocolValid
global function GetPromoDataVersion
global function GetPromoDataLayout
global function GetPromoImage

global function GetPromoRpakName
global function GetMiniPromoRpakName

global function UICodeCallback_MainMenuPromosUpdated

#if DEVELOPER
global function DEV_PrintPromoData
#endif //

//
//
const int PROMO_PROTOCOL = 2

struct
{
	MainMenuPromos&      promoData
	table<string, asset> imageMap
} file

string function GetPromoRpakName()
{
	return file.promoData.promoRpak
}

string function GetMiniPromoRpakName()
{
	return file.promoData.miniPromoRpak
}

void function InitPromoData()
{
	RequestMainMenuPromos() //

	var dataTable = GetDataTable( $"datatable/promo_images.rpak" )
	for ( int i = 0; i < GetDatatableRowCount( dataTable ); i++ )
	{
		string name = GetDataTableString( dataTable, i, GetDataTableColumnByName( dataTable, "name" ) ).tolower()
		asset image = GetDataTableAsset( dataTable, i, GetDataTableColumnByName( dataTable, "image" ) )
		if ( name != "" )
			file.imageMap[name] <- image
	}
}


void function UpdatePromoData()
{
	#if DEVELOPER
		//if ( GetConVarBool( "mainMenuPromos_scriptUpdateDisabled" ) || GetCurrentPlaylistVarBool( "mainMenuPromos_scriptUpdateDisabled", false ) )
		//	return
	#endif //
	file.promoData = GetMainMenuPromos()
}

void function TEMP_UpdatePromoData()
{
	MainMenuPromos skypad
	skypad.prot = PROMO_PROTOCOL
	skypad.version = 1
	skypad.layout = "This should be a string that contains image title and desc, InitPages funct cleans it using regex"
	skypad.promoRpak = $""
	skypad.miniPromoRpak = $""

	file.promoData = skypad
}

void function UICodeCallback_MainMenuPromosUpdated()
{
	TEMP_UpdatePromoData()
}


bool function IsPromoDataProtocolValid()
{
	return file.promoData.prot == PROMO_PROTOCOL
}


int function GetPromoDataVersion()
{
	return file.promoData.version
}


string function GetPromoDataLayout()
{
	return file.promoData.layout
}


asset function GetPromoImage( string identifier )
{
	identifier = identifier.tolower()

	asset image
	if ( identifier in file.imageMap )
		image = file.imageMap[identifier]
	else
		image = $"rui/promo/apex_title"

	return image
}

#if DEVELOPER
void function DEV_PrintPromoData()
{
	printt( "protocol:      ", file.promoData.prot )
	printt( "version:       ", file.promoData.version )
	printt( "promoRpak:     ", file.promoData.promoRpak )
	printt( "miniPromoRpak: ", file.promoData.miniPromoRpak )
	printt( "layout:        ", file.promoData.layout )
}
#endif //