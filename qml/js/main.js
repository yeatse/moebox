.pragma library

Qt.include("sha1.js");
Qt.include("oauth.js");
Qt.include("MService.js");

var msettings;
var signalCenter;

function initialize(sc, ms){
    signalCenter = sc||signalCenter;
    msettings = ms||msettings;

    //Get user data to ensure the token is effective.
    if (msettings.token != "" && msettings.tokenSecret != ""){
        MApi.token = msettings.token;
        MApi.tokenSecret = msettings.tokenSecret;
        signalCenter.setLoadingIndicator(true);
        function s(user){
            signalCenter.setLoadingIndicator(false);
            msettings.userDetail = user;
            msettings.isLogin = true;
            signalCenter.initialized();
        }
        function f(err){
            console.log("login failed:"+err);
            signalCenter.setLoadingIndicator(false);
            msettings.token = "";
            msettings.tokenSecret = "";
            MApi.token = "";
            MApi.tokenSecret = "";
            msettings.isLogin = false;
            signalCenter.initialized();
        }
        getUserDetail({}, s, f);
    } else {
        msettings.token = "";
        msettings.tokenSecret = "";
        MApi.token = "";
        MApi.tokenSecret = "";
        msettings.isLogin = false;
        signalCenter.initialized();
    }
}

// Request OAuthToken
function requestToken(onSuccess, onFailed){
    MApi.token = "";
    MApi.tokenSecret = "";
    var req = new OAuthRequest(MApi.requestTokenURL, "POST");
    var param = {
        oauth_consumer_key: MApi.consumerKey,
        oauth_signature_method: MApi.signatureMethod
    }
    req.signForm(param);

    function s(resp){
        var map = OAuth.getParameterMap(resp);
        MApi.token = map.oauth_token;
        MApi.tokenSecret = map.oauth_token_secret;

        authorize(onSuccess, onFailed);
    }

    req.sendRequest(s, onFailed);
}

// Should be used togethor with 'requestToken'
// Return url of auth page through 'onSuccess'
function authorize(onSuccess, onFailed){
    if (MApi.token == "") return onFailed("token required");

    var req = new OAuthRequest(MApi.userAuthorizationURL);
    var param = {
        oauth_token: MApi.token,
        oauth_callback: MApi.callbackURL
    }
    req.signForm(param);

    var authUrl = OAuth.addToURL(req.action, req.parameterMap);

    onSuccess(authUrl);
}

// Request access token
function accessToken(onSuccess, onFailed){
    var req = new OAuthRequest(MApi.accessTokenURL, "POST");
    var param = {
        oauth_consumer_key: MApi.consumerKey,
        oauth_token: MApi.token,
        oauth_signature_method: MApi.signatureMethod
    }
    req.signForm(param);
    function s(resp){
        var map = OAuth.getParameterMap(resp);
        MApi.token = map.oauth_token;
        MApi.tokenSecret = map.oauth_token_secret;
        msettings.tokenSecret = map.oauth_token_secret;
        msettings.token = map.oauth_token;
        onSuccess();
    }

    req.sendRequest(s, onFailed);
}

// Request playlist
function getPlaylist(option, onSuccess, onFailed){
    var req = new OAuthRequest(MApi.listen_playlist);

    if (msettings.isLogin){
        var param = {
            api: "json",
            oauth_consumer_key: MApi.consumerKey,
            oauth_token: MApi.token,
            oauth_signature_method: MApi.signatureMethod
        }
        if (option.fav) param.fav = option.fav;
        if (option.page) param.page = option.page;
        req.signForm(param);
    }

    function s(resp){
        var obj = JSON.parse(resp);
        var list = obj.playlist || obj.response.playlist;
        var info = obj.info || obj.response.information;
        var model = option.model;

        if (option.random){
            //Reorder the list by random
            list.sort(function(){ return Math.random()>0.5?-1:1; });
        }

        list.forEach(function(item){
                         item.isFav = item.fav_sub ? true : false;
                         model.append(item);
                     });

        onSuccess(info);
    }

    req.sendRequest(s, onFailed);
}

// User detail
function getUserDetail(option, onSuccess, onFailed){
    var req = new OAuthRequest(MApi.user_detail);
    var param = {
        oauth_consumer_key: MApi.consumerKey,
        oauth_token: MApi.token,
        oauth_signature_method: MApi.signatureMethod
    }

    if (option.uid) param.uid = option.uid;
    else if (option.user_name) param.user_name = option.user_name;

    req.signForm(param);

    function s(resp){
        var res = JSON.parse(resp).response;
        if (res.information.has_error){
            onFailed(res.information.msg);
        } else {
            onSuccess(res.user);
        }
    }
    req.sendRequest(s, onFailed);
}

function logRecord(sub_id){
    var req = new OAuthRequest(MApi.ajax_log);
    var param = {
        oauth_consumer_key: MApi.consumerKey,
        oauth_token: MApi.token,
        oauth_signature_method: MApi.signatureMethod,
        log_obj_type: "sub",
        log_type: "listen",
        obj_type: "song",
        obj_id: sub_id,
        api: "json"
    }
    req.signForm(param);
    function s(resp){
        var res = JSON.parse(resp).response;
        if (res.information.has_error){
            console.log("log failed=======================\n",
                        resp);
        } else {
            console.log("log success");
        }
    }
    req.sendRequest(s, new Function());
}

function manageFav(option, onSuccess, onFailed){
    var url = option.add ? MApi.fav_add : MApi.fav_delete;
    var req = new OAuthRequest(url);
    var param = {
        oauth_consumer_key: MApi.consumerKey,
        oauth_token: MApi.token,
        oauth_signature_method: MApi.signatureMethod,
        fav_obj_type: option.sub_type||"song",
        fav_obj_id: option.sub_id,
        fav_type: option.fav_type
    }
    req.signForm(param);
    function s(resp){
        var res = JSON.parse(resp).response;
        if (res.information.has_error){
            onFailed(res.information.msg);
        } else {
            onSuccess(option);
        }
    }
    req.sendRequest(s, onFailed);
}
