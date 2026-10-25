# Relatório de verificação — Cloud-Init Lab

**Data:** 25/10/2026  
**Repositório:** https://github.com/ellenyass/cloud-init_lab  

## user-data implementado

Conforme o [guia de apoio Cloud-Init](guia_apoio_cloud-init.pdf):

| Requisito | Implementação |
|-----------|----------------|
| Atualizar listas APT | `package_update: true` |
| Usuário admin | `meu-usuario` com `groups: [sudo]`, `sudo: ALL=(ALL) NOPASSWD:ALL`, `lock_passwd: true` |
| SSH | Chave pública em `ssh_authorized_keys` (arquivo `chave-publica-ssh.txt`) |
| Pacotes | `docker.io`, `nginx` |
| Página web | `write_files` → `/var/www/html/index.html` |
| runcmd | `systemctl enable --now nginx`, `docker`, `usermod -aG docker meu-usuario` |
| Mensagem final | `final_message` |

## Chave SSH (Windows)

Gerada com `ssh-keygen -t ed25519`. A chave **privada** permanece em `%USERPROFILE%\.ssh\id_ed25519` (não versionada).

## Validação funcional

O fluxo NoCloud do repositório (`cloud-init_setup.sh` + seed em `/var/lib/cloud/seed/nocloud/`) foi exercitado em container Ubuntu 22.04 com systemd (espelhando Jammy + portas 80→8080).

### Resultados

- **Usuário:** `uid=1000(meu-usuario)` — grupos `sudo` e `docker`
- **Nginx:** `active (running)`
- **Docker:** `active (running)`
- **Página:** HTTP **200** em http://127.0.0.1:8080/
- **Cloud-Init:** `errors: []` em `cloud-init status --long` (ver `verificacao.txt`)

### Evidências

- `verificacao.txt` — saída completa dos testes
- `capturas/pagina-web-8080.png` — página personalizada no navegador
- `capturas/servicos-systemctl.txt` — status de Nginx e Docker
- `servicos-status.txt` — `systemctl is-active` para ambos os serviços

## Vagrant (procedimento oficial)

1. Instale [VirtualBox](https://www.virtualbox.org/) e [Vagrant](https://developer.hashicorp.com/vagrant/install) (a instalação via winget pode exigir conclusão manual do MSI).
2. Na pasta do projeto:

```powershell
vagrant destroy -f
vagrant up
vagrant reload
vagrant ssh -c "cloud-init status --long"
```

3. Abra http://127.0.0.1:8080 e conecte via SSH:

```powershell
ssh -i $env:USERPROFILE\.ssh\id_ed25519 meu-usuario@192.168.33.10
```

## Entrega

- **Solução:** commit/push de `user-data` e pasta `artefatos/` para o fork em GitHub
- **Artefatos:** esta pasta `artefatos/`
