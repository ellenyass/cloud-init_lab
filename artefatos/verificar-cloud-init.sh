#!/bin/bash
# Executado dentro da VM/container após cloud-init_setup.sh e inicialização do cloud-init.
set -e
OUT=/tmp/evidencias
mkdir -p "$OUT"

{
  echo "=== cloud-init status ==="
  cloud-init status --long || true
  echo
  echo "=== id meu-usuario ==="
  id meu-usuario || true
  echo
  echo "=== groups meu-usuario ==="
  groups meu-usuario || true
  echo
  echo "=== nginx ==="
  systemctl is-active nginx || true
  systemctl status nginx --no-pager -l || true
  echo
  echo "=== docker ==="
  systemctl is-active docker || true
  systemctl status docker --no-pager -l || true
  echo
  echo "=== index.html ==="
  ls -l /var/www/html/index.html || true
  head -5 /var/www/html/index.html || true
  echo
  echo "=== curl localhost ==="
  curl -sS -o /dev/null -w "HTTP %{http_code}\n" http://127.0.0.1/ || true
  curl -sS http://127.0.0.1/ | head -20 || true
} | tee "$OUT/verificacao.txt"

cp "$OUT/verificacao.txt" /evidencias/verificacao.txt 2>/dev/null || true
