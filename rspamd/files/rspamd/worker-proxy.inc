bind_socket: "0.0.0.0:11332";

milter = yes;
timeout = 120s;
upstream "local" {
    default = yes;
    self_scan = yes;
}

count = 4;
discard_on_reject = false;
quarantine_on_reject = false;

spam_header = "X-Spam"
