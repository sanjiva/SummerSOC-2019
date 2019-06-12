import ballerina/http;
import ballerina/log;

listener http:Listener http2ServiceEP = new(7090,
    config = { httpVersion: "2.0" });

@http:ServiceConfig {
    basePath: "/http2Service"
}
service http2Service on http2ServiceEP {
    @http:ResourceConfig {
        path: "/"
    }
    resource function http2Resource(http:Caller caller, http:Request req) {
        http:PushPromise promise1 = new(path = "/resource1", method = "GET");
        var promiseResponse1 = caller->promise(promise1);
        if (promiseResponse1 is error) {
            log:printError("Error occurred while sending the promise1",
                err = promiseResponse1);
        }

        http:PushPromise promise2 = new(path = "/resource2", method = "GET");
        var promiseResponse2 = caller->promise(promise2);
        if (promiseResponse2 is error) {
            log:printError("Error occurred while sending the promise2",
                err = promiseResponse2);
        }

        http:PushPromise promise3 = new(path = "/resource3", method = "GET");
        var promiseResponse3 = caller->promise(promise3);
        if (promiseResponse3 is error) {
            log:printError("Error occurred while sending the promise3",
                err = promiseResponse3);
        }

        http:Response res = new;
        json msg = { "response": { "name": "main resource" } };
        res.setPayload(msg);

        var response = caller->respond(res);
        if (response is error) {
            log:printError("Error occurred while sending the response",
                err = response);
        }

        http:Response push1 = new;
        msg = { "push": { "name": "resource1" } };
        push1.setPayload(msg);

        var pushResponse1 = caller->pushPromisedResponse(promise1, push1);
        if (pushResponse1 is error) {
            log:printError("Error occurred while sending the promised response1",
                err = pushResponse1);
        }

        http:Response push2 = new;
        msg = { "push": { "name": "resource2" } };
        push2.setPayload(msg);

        var pushResponse2 = caller->pushPromisedResponse(promise2, push2);
        if (pushResponse2 is error) {
            log:printError("Error occurred while sending the promised response2",
                err = pushResponse2);
        }

        http:Response push3 = new;
        msg = { "push": { "name": "resource3" } };
        push3.setPayload(msg);

        var pushResponse3 = caller->pushPromisedResponse(promise3, push3);
        if (pushResponse3 is error) {
            log:printError("Error occurred while sending the promised response3",
                err = pushResponse3);
        }
    }
}