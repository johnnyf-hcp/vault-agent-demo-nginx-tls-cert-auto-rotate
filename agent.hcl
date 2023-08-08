exit_after_auth = false
pid_file = "./pidfile"

vault {
  address = "http://127.0.0.1:8200"
  retry {
    num_retries = 5
  }
}

auto_auth {
   method "approle" {
       mount_path = "auth/approle"
       config = {
           role_id_file_path = "roleid"
           secret_id_file_path = "secretid"
           remove_secret_id_file_after_reading = false
       }
   }

  sink {
    type = "file"
    config = {
      path = "./agent-token"
    }
  }
}

cache {
  use_auto_auth_token = true
}

listener "tcp" {
  address = "127.0.0.1:8100"
  tls_disable = true
}

template {
  source = "cert.key.ctmpl"
  destination = "/opt/homebrew/etc/nginx/cert.key"
}

template {
  source = "cert.pem.ctmpl"
  destination = "/opt/homebrew/etc/nginx/cert.pem"
  command="nginx -s reload"
}

