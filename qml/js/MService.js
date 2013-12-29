var MApi = {
    consumerKey: "50f06e30146f68b26647115e46dd7aa705223e58d",
    consumerSecret: "6c0701c29e6b9702004d8b3ea300a454",
    token: "",
    tokenSecret: "",
    signatureMethod: "HMAC-SHA1",

    requestTokenURL: "http://api.moefou.org/oauth/request_token",
    userAuthorizationURL: "http://api.moefou.org/oauth/authorize",
    accessTokenURL: "http://api.moefou.org/oauth/access_token",
    callbackURL: "",

    listen_playlist: "http://moe.fm/listen/playlist",
    user_detail: "http://api.moefou.org/user/detail.json",
    ajax_log: "http://moe.fm/ajax/log",
    fav_add: "http://api.moefou.org/fav/add.json",
    fav_delete: "http://api.moefou.org/fav/delete.json"
}

var OAuthRequest = function(action, method){
    this.action = action;
    this.method = method || "GET";
    this.parameterMap = {};
}

OAuthRequest.prototype.signForm = function(parameters){
            var accessor = {
                consumerSecret: MApi.consumerSecret,
                tokenSecret: MApi.tokenSecret
            };
            var message = {
                action: this.action,
                method: this.method,
                parameters: []
            };
            for (var key in parameters){
                var value = parameters[key];
                message.parameters.push([key, value]);
            }
            OAuth.setTimestampAndNonce(message);
            OAuth.SignatureMethod.sign(message, accessor);
            this.parameterMap = OAuth.getParameterMap(message.parameters);
        }

OAuthRequest.prototype.sendRequest = function(onSuccess, onFailed){
            console.log("===================\n",
                        this.method,
                        this.action,
                        "\n",
                        OAuth.formEncode(this.parameterMap));
            var xhr = new XMLHttpRequest();
            xhr.onreadystatechange = function(){
                        if (xhr.readyState == xhr.DONE){
                            if (xhr.status == 200){
                                try {
                                    onSuccess(xhr.responseText);
                                } catch (e){
                                    onFailed(JSON.stringify(e));
                                }
                            } else {
                                onFailed(xhr.status);
                            }
                        }
                    }
            if (this.method === "GET"){
                var url = OAuth.addToURL(this.action, this.parameterMap);
                xhr.open("GET", url);
                xhr.send();
            } else if (this.method === "POST"){
                var toPost = OAuth.formEncode(this.parameterMap);
                xhr.open("POST", this.action);
                xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
                xhr.setRequestHeader("Content-Length", toPost.length);
                xhr.send(toPost);
            }
        }
