#include <string>
#include <glog/logging.h>
#include <gflags/gflags.h>

#include <brpc/server.h>
#include "proto/httpserver.pb.h"

using namespace std;

DEFINE_bool(render, true, "enable render - deprecated");
DEFINE_string(config, "config.json", "Config file path");
DEFINE_int32(gpu,0,"gpu id - deprecated");
DEFINE_bool(debug, false, "run as debug mode");

const std::string CONST_BIN_VERSION = "Vse Version: " + GetBinVersion();

void signalHandler(int sig)
{
    LOG(WARNING) << "Killed by user. Goodbye :)";
    exit(0);
}

void SignalErrorHandle(const char* data, int size)
{

}

int main(int argc, char** argv) {

    FLAGS_max_log_size = 100;
    FLAGS_logbufsecs = 10; //默认30秒输出日志
    FLAGS_colorlogtostderr = true;
    FLAGS_logtostderr = true;

    signal(SIGINT, signalHandler);
    google::SetVersionString(CONST_BIN_VERSION);
    google::InitGoogleLogging(argv[0]);
    google::SetUsageMessage("Usage: " + string(argv[0]) + "[--config=config.json]");
    google::ParseCommandLineFlags(&argc, &argv, false);

    brpc::Server server;
    HttpService http_svc();
    if (server.AddService(&http_svc,
                          brpc::SERVER_DOESNT_OWN_SERVICE,
                          "/vse/ping   => Ping,"
                          "/vse/version   => Version,"
                          "/vse/config   => GetConfig,"
                          "/vse/taskconfig   => GetTaskConfig,"
                          "/vse/resource   => GetAllResource,"
                          "/vse/*/info   => Debug_Callback,"
                          "/vse/debug/log/kafka => LogCheck,"
                          "/vse/debug/rmall => RemoveAll,"
                          "/vse/debug/tasksplit => NewTaskWithSplit,"
                          "/vse/task/new => NewTask,"
                          "/vse/task/rm => RemoveTask,"
                          "/vse/task/status/* => Status,"
                          "/vse/task/mediainfo => MediaInfo,"
                          "/vse/task/metadata => MediaInfo,"
                          "/vse/task/screenshot => Screenshot,"
                          "/vse/task/watch => Watch,"
                          "/vse/catalog => Catalog") != 0) {
        LOG(ERROR) << "Fail to add vse_http_svc";
        return -1;
    }

    int32_t http_port = pConfig->_config.port().http_port();
    string default_conf = pConfig->_config.conf().defaultvsdconf();
    int32_t threads = pConfig->_config.httpthreads();

    brpc::ServerOptions options;
    options.max_concurrency = threads*10;
    options.num_threads = threads;
    server.set_version(CONST_BIN_VERSION);

    if (server.Start(http_port, &options) != 0) {
        LOG(ERROR) << "Fail to start HttpServer";
        return -1;
    }

    // Wait until Ctrl-C is pressed, then Stop() and Join() the server.
    server.RunUntilAskedToQuit();
    return 0;
}