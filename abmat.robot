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
    Sleep  3 seconds
    ${lista}=  Get WebElements  xpath://*[@id="wrap"]/aside/div/label/ul/li[@data-main="25"]
    :FOR    ${element}  IN  @{lista}
#        ${sub}=  Get Element Attribute  ${element}  data-sub
#        ${xpathForClic}=  Catenate  SEPARATOR=  //*[@id="wrap"]/aside/div/label/ul/li[@data-main="25"][@data-sub="  ${sub}  "]
#        Click Element  ${xpathForClic}
        Click Element   ${element}
        Sleep  10 seconds
    END
