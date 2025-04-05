#!/bin/bash

# Nome do script
SCRIPT_NAME="MARCONES_MS"

# Funções do script
criar_login() {
    echo -ne "Usuário: "; read user
    echo -ne "Senha: "; read pass
    echo -ne "Dias de validade: "; read dias
    useradd -M -s /bin/false $user
    (echo "$pass"; echo "$pass") | passwd $user > /dev/null 2>&1
    chage -E $(date -d "+$dias days" +%Y-%m-%d) $user
    echo "Usuário $user criado com sucesso."
    read -p "Pressione Enter para voltar ao menu..."
    show_menu
}

criar_login_teste() {
    user="teste$RANDOM"
    pass="123"
    useradd -M -s /bin/false $user
    echo -e "$pass\n$pass" | passwd $user > /dev/null 2>&1
    chage -E $(date -d "+1 day" +%Y-%m-%d) $user
    echo "Login teste criado: $user | Senha: $pass (1 dia de validade)"
    read -p "Pressione Enter para voltar ao menu..."
    show_menu
}

remover_login() {
    echo -ne "Usuário para remover: "; read user
    userdel -f $user && echo "Usuário $user removido." || echo "Usuário não encontrado."
    read -p "Pressione Enter para voltar ao menu..."
    show_menu
}

usuarios_online() {
    echo "Usuários conectados via SSH:" 
    ps aux | grep sshd | grep -v grep
    read -p "Pressione Enter para voltar ao menu..."
    show_menu
}

mudar_data() {
    echo -ne "Usuário: "; read user
    echo -ne "Dias a adicionar: "; read dias
    chage -E $(date -d "+$dias days" +%Y-%m-%d) $user
    echo "Validade do usuário $user alterada."
    read -p "Pressione Enter para voltar ao menu..."
    show_menu
}

alterar_limite() {
    echo "Função de limite não implementada neste exemplo."
    read -p "Pressione Enter para voltar ao menu..."
    show_menu
}

mudar_senha() {
    echo -ne "Usuário: "; read user
    echo -ne "Nova senha: "; read senha
    echo -e "$senha\n$senha" | passwd $user
    echo "Senha alterada com sucesso."
    read -p "Pressione Enter para voltar ao menu..."
    show_menu
}

remover_expirados() {
    for user in $(cut -d: -f1 /etc/passwd); do
        data=$(chage -l $user | grep "Account expires" | cut -d: -f2)
        if [[ "$data" != " never" && "$data" != "never" ]]; then
            exp=$(date -d "$data" +%s)
            hoje=$(date +%s)
            if [ $hoje -ge $exp ]; then
                userdel -f $user
                echo "Removido usuário expirado: $user"
            fi
        fi
    done
    read -p "Pressione Enter para voltar ao menu..."
    show_menu
}

relatorio_usuarios() {
    echo "Usuários ativos e validade:"
    for user in $(cut -d: -f1 /etc/passwd); do
        exp=$(chage -l $user | grep "Account expires" | cut -d: -f2)
        echo "$user - Expira em:$exp"
    done
    read -p "Pressione Enter para voltar ao menu..."
    show_menu
}

modos_conexao() {
    echo "Detectando modos de conexão ativos na VPS..."
    echo "--------------------------------------------"

    echo "🔐 OpenSSH:"
    ps -ef | grep sshd | grep -v grep > /dev/null && \
    echo "Ativo na(s) porta(s): $(netstat -tunlp | grep sshd | awk '{print $4}' | cut -d: -f2 | sort -u)" || \
    echo "❌ Não encontrado."

    echo ""
    echo "📦 Dropbear:"
    ps -ef | grep dropbear | grep -v grep > /dev/null && \
    echo "Ativo na(s) porta(s): $(netstat -tunlp | grep dropbear | awk '{print $4}' | cut -d: -f2 | sort -u)" || \
    echo "❌ Não encontrado."

    echo ""
    echo "🔒 SSL/TLS (stunnel):"
    ps -ef | grep stunnel | grep -v grep > /dev/null && \
    echo "Ativo na(s) porta(s): $(netstat -tunlp | grep stunnel | awk '{print $4}' | cut -d: -f2 | sort -u)" || \
    echo "❌ Não encontrado."

    echo ""
    echo "🌐 OpenVPN:"
    ps -ef | grep openvpn | grep -v grep > /dev/null && \
    echo "Ativo na(s) porta(s): $(netstat -tunlp | grep openvpn | awk '{print $4}' | cut -d: -f2 | sort -u)" || \
    echo "❌ Não encontrado."

    echo "--------------------------------------------"
    read -p "Pressione Enter para voltar ao menu..."
    show_menu
}

suspender_usuario() {
    echo -ne "Usuário a suspender: "; read user
    usermod -L $user
    echo "Usuário $user suspenso."
    read -p "Pressione Enter para voltar ao menu..."
    show_menu
}

otimizar() {
    apt-get clean && apt-get autoremove -y
    echo "Sistema otimizado."
    read -p "Pressione Enter para voltar ao menu..."
    show_menu
}

backup() {
    tar czf backup_ssh_$(date +%F).tar.gz /etc/passwd /etc/shadow /etc/group /etc/gshadow
    echo "Backup criado em: backup_ssh_$(date +%F).tar.gz"
    read -p "Pressione Enter para voltar ao menu..."
    show_menu
}

info_vps() {
    echo "Informações da VPS:"
    uname -a
    lsb_release -a
    free -h
    df -h
    read -p "Pressione Enter para voltar ao menu..."
    show_menu
}

ferramentas() {
    echo "Funções extras em breve."
    read -p "Pressione Enter para voltar ao menu..."
    show_menu
}

checkusers() {
    who
    read -p "Pressione Enter para voltar ao menu..."
    show_menu
}

online_app() {
    netstat -tunlp
    read -p "Pressione Enter para voltar ao menu..."
    show_menu
}

speedtest() {
    if ! command -v speedtest > /dev/null; then
        apt-get install -y speedtest-cli > /dev/null 2>&1
    fi
    speedtest
    read -p "Pressione Enter para voltar ao menu..."
    show_menu
}

banner() {
    nano /etc/issue.net
    echo "Banner alterado. Reinicie o SSH para aplicar."
    read -p "Pressione Enter para voltar ao menu..."
    show_menu
}

trafego() {
    if ! command -v vnstat > /dev/null; then
        apt-get install -y vnstat > /dev/null 2>&1
    fi
    vnstat
    read -p "Pressione Enter para voltar ao menu..."
    show_menu
}

# Função para exibir o menu
show_menu() {
    clear
    echo -e "\e[1;34m========================================\e[0m"
    echo -e "\e[1;32m        SCRIPT DO MARCONES_MS           \e[0m"
    echo -e "\e[1;34m========================================\e[0m"
    echo -e "\e[1;33mSistema: $(lsb_release -d | cut -f2)"
    echo -e "Memória Ram: $(free -m | awk 'NR==2{print $2}') MB Total"
    echo -e "Processador: $(nproc) Núcleos\e[0m"
    echo -e "----------------------------------------"
    echo -e " 01 - Criar Login         12 - Otimizar"
    echo -e " 02 - Criar Login Teste   13 - Backup"
    echo -e " 03 - Remover Login       14 - Limiter ❌"
    echo -e " 04 - Usuários Online     15 - Bad VPN ❌"
    echo -e " 05 - Mudar Data          16 - Info VPS"
    echo -e " 06 - Alterar Limite      17 - Ferramentas"
    echo -e " 07 - Mudar Senha         18 - CheckUsers"
    echo -e " 08 - Remover Expirados   19 - Online App"
    echo -e " 09 - Relatório Usuários  20 - Speedtest"
    echo -e " 10 - Modos de Conexão    21 - Banner"
    echo -e " 11 - Suspender Usuário   22 - Tráfego"
    echo -e " 00 - Sair"
    echo -e "----------------------------------------"
    echo -ne "O QUE DESEJA FAZER ? : "
    read option
    case "$option" in
        1) criar_login ;;
        2) criar_login_teste ;;
        3) remover_login ;;
        4) usuarios_online ;;
        5) mudar_data ;;
        6) alterar_limite ;;
        7) mudar_senha ;;
        8) remover_expirados ;;
        9) relatorio_usuarios ;;
        10) modos_conexao ;;
        11) suspender_usuario ;;
        12) otimizar ;;
        13) backup ;;
        16) info_vps ;;
        17) ferramentas ;;
        18) checkusers ;;
        19) online_app ;;
        20) speedtest ;;
        21) banner ;;
        22) trafego ;;
        0) exit 0 ;;
        *) echo "Opção inválida!" ; sleep 2 ; show_menu ;;
    esac
}

# Função principal
show_menu
