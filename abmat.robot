*** Settings ***
Documentation     Gets the most requested data for DBO Market
Resource          resource.robot

*** Test Cases ***
Main test case
    Login
    Scrap


*** Keywords ***
Login
    Open Browser     ${MARKET_URL}          ${BROWSER}          alias=BDoBrowser
    Input Text       id:user_email         ${EMAIL}
    Input Text       id:user_password      ${PASSWORD}
    Click Element    name:commit
    Input Password   id:inputSecondPwd     ${MARKET_PASSWORD}
    Click Element    id:confirmSecondPwd
    # Wait a little for ajax animation to complete
    Sleep  5 seconds

Scrap
    # data-main=25 is the "Material" category
    Wait Until Element Is Visible  xpath://*[@id="wrap"]/aside/div/label/h4/span[text()="Material"]
    Click Element  xpath://*[@id="wrap"]/aside/div/label/h4/span[text()="Material"]
    # Wait a little for accordion animation to complete
    Sleep  5 seconds
    ${subcategories_elements}=  Get WebElements  xpath://*[@id="wrap"]/aside/div/label/ul/li[@data-main="25"]
    ${subcategories}=  Create List
    :FOR  ${subel}  IN  ${subcategories_elements}
        ${sub}=  Get Attribute  ${subel}  data-sub
        Append To List  ${subcategories}  ${sub}
    END
    Iterate over subcategories  @{subcategories}

Iterate over subcategories
    [Arguments]  @{subcategories}
    :FOR  ${sub}  IN  @{subcategories}
        ${xpathsub}=  Catenate  SEPARATOR=  //*[@id="wrap"]/aside/div/label/ul/li[@data-main="25"][@data-sub="  ${sub}  "]
        Click Element  ${xpathsub}
        # Wait a little for accordion animation to complete
        Sleep  3 seconds
        ${marketitems}=  Get WebElements  xpath://*[@id="market"]/div
        Iterate over items  @{marketitems}
    END

Iterate over items
    [Arguments]  @{marketitems}
    :FOR  ${mki}  IN  @{marketitems}
        Log  ${mki}
        Click Element  ${mki}
        # Wait a little for accordion animation to complete
        Sleep  3 seconds
        Click button  css:.btnArrowLeft
        # Wait a little for accordion animation to complete
        Sleep  3 seconds
#            Click Element  css:#btnBuy
#            # Wait a little for animation to complete
#            Sleep  3 seconds
#            Click Element  css:#btnCancel
#            # Wait a little for animation to complete
#            Sleep  3 seconds
    END
