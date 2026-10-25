# Artefatos — Cloud-Init Lab

## Conteúdo

| Arquivo | Descrição |
|---------|-----------|
| `user-data` (raiz do repo) | cloud-config com pacotes, usuário, página Nginx e runcmd |
| `chave-publica-ssh.txt` | Chave **pública** OpenSSH de `meu-usuario` (sem chave privada) |
| `verificacao.txt` | Saída dos comandos de validação (cloud-init, serviços, HTTP) |
| `capturas/` | Screenshots da página web e dos serviços |
| `docker-provision.sh` | Script auxiliar para validar o user-data em ambiente Linux com systemd |

## Procedimento Vagrant (repositório)

```powershell
cd c:\Users\caval\dev\cloud-init_lab
vagrant destroy -f   # se já existir VM
vagrant up
vagrant reload       # após o provisionamento do cloud-init_setup.sh
vagrant ssh -c "cloud-init status --long"
vagrant ssh -c "id meu-usuario && systemctl is-active nginx docker"
```

Acesse a página: http://127.0.0.1:8080 (porta encaminhada no `Vagrantfile`).

## SSH

```powershell
ssh -i $env:USERPROFILE\.ssh\id_ed25519 meu-usuario@192.168.33.10
```
