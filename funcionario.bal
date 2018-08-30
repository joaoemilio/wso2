import ballerina/http;
import ballerina/log;

type Funcionario record {
    int id,
    int idade,
    string nome,
};

endpoint http:Listener funcionarioEP {
    port: 9095
};

@http:ServiceConfig {
    basePath: "/"
}
service funcionarioService bind funcionarioEP {
    @http:ResourceConfig {
        methods: ["GET"],
        path: "/funcionario"
    }    
    
    getAll(endpoint caller, http:Request req) {
        http:Response res = new;
        json funcionario = [{
            nome: "Joao Emilio",
            idade: 38,
            empresa: "WSO2"
        },{
            nome: "Roberto Monteiro",
            idade: 38,
            empresa: "WSO2"
        }];
        res.setPayload( funcionario );
        caller->respond(res) but {
                    error e => log:printError("Error in responding ", err = e) };
    }
    @http:ResourceConfig {
        methods: ["POST"],
        body: "funcionario",
        path: "/pagar"
    }    
    
    pagarFuncionario(endpoint caller, http:Request req, json funcionario) {
        http:Response res = new;

        log:printInfo("payload: " + funcionario.funcionario.toString() );

        if (!check funcionario.funcionario.id.toString().matches("\\d+")) {
            res.statusCode = 400;
            res.setPayload("Payload nao tem informacoes suficiente");
        } else {
            res.setPayload(untaint funcionario.funcionario);
        }

        caller->respond(res) but {
                    error e => log:printError("Error in responding ", err = e) };
    }
}
