<?php

use INTERMediator\DB\UseSharedObjects;
use INTERMediator\DB\Extending\AfterRead;
use INTERMediator\Params;
use PragmaRX\Google2FA\Google2FA;

class RegisterAddURL extends UseSharedObjects implements AfterRead
{
    public function doAfterReadFromDB($result)
    {
//        $secret = $google2fa->generateSecretKey();
//        $userName = $this->proxyObject->paramAuthUser;
//        [$uid, , , , $secret] = $this->proxyObject->dbClass->authHandler->getLoginUserInfo($userName);
        $qrCodeUrl = '';
        $secret = $result[0]['secret'] ?? '';
        if($secret) {
            $serverName = Params::getParameterValue("authRealm", $_SERVER["SERVER_NAME"]);
            $google2fa = new Google2FA();
            $qrCodeUrl = $google2fa->getQRCodeUrl($serverName, $result[0]['username'], $secret);
        }
//        $this->proxyObject->dbClass->authHandler->authSupportStore2FASecret($uid, $secret);
        $result[0]['qrcodeurl'] = $qrCodeUrl;
        return $result;
    }
}