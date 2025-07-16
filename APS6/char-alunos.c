#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/fs.h>
#include <linux/uaccess.h>

#define DEVICE_NAME "chardevice"
#define BUF_LEN 1024

static int major;                   // Número major do driver
static char msg[BUF_LEN] = { 0 };    // Buffer interno do driver
static short msg_size = 0;         // Tamanho da mensagem armazenada
static int device_open = 0;        // Flag para evitar múltiplas aberturas simultâneas

// Prototipação das funções
static int device_open_fn(struct inode*, struct file*);
static int device_release_fn(struct inode*, struct file*);
static ssize_t device_read_fn(struct file*, char*, size_t, loff_t*);
static ssize_t device_write_fn(struct file*, const char*, size_t, loff_t*);

// Estrutura de operações do driver
static struct file_operations fops = {
    .read = device_read_fn,
    .write = device_write_fn,
    .open = device_open_fn,
    .release = device_release_fn,
};

// Função de inicialização do módulo
static int __init device_init(void) {
    major = register_chrdev(0, DEVICE_NAME, &fops);
    if (major < 0) {
        printk(KERN_ALERT "Falha ao registrar o driver.\n");
        return major;
    }
    printk(KERN_INFO "Driver carregado com sucesso. Major = %d\n", major);
    printk(KERN_INFO "Crie o device file com: mknod /dev/%s c %d 0\n", DEVICE_NAME, major);
    return 0;
}

// Função de saída do módulo
static void __exit device_exit(void) {
    unregister_chrdev(major, DEVICE_NAME);
    printk(KERN_INFO "Driver removido com sucesso.\n");
}

// Quando o dispositivo é aberto
static int device_open_fn(struct inode* inode, struct file* file) {
    if (device_open) {
        return -EBUSY; // Dispositivo já está aberto
    }
    device_open++;
    try_module_get(THIS_MODULE); // Incrementa contador de uso do módulo
    printk(KERN_INFO "Dispositivo %s aberto\n", DEVICE_NAME);
    return 0;
}

// Quando o dispositivo é fechado
static int device_release_fn(struct inode* inode, struct file* file) {
    device_open--;
    module_put(THIS_MODULE); // Decrementa contador de uso do módulo
    printk(KERN_INFO "Dispositivo %s fechado\n", DEVICE_NAME);
    return 0;
}

// Leitura do dispositivo para o espaço do usuário
static ssize_t device_read_fn(struct file* filp, char* buffer, size_t length, loff_t* offset) {
    int bytes_read = 0;

    if (*offset >= msg_size) {
        return 0; // Fim do arquivo
    }

    while (length && *offset < msg_size) {
        if (put_user(msg[*offset], buffer++)) {
            return -EFAULT; // Falha ao copiar para o usuário
        }
        *offset += 1;
        bytes_read++;
        length--;
    }

    printk(KERN_INFO "Leitura de %d bytes\n", bytes_read);
    return bytes_read;
}

// Escrita do espaço do usuário para o dispositivo
static ssize_t device_write_fn(struct file* filp, const char* buffer, size_t length, loff_t* offset) {
    if (length > BUF_LEN - 1) {
        length = BUF_LEN - 1; // Evita overflow
    }

    if (copy_from_user(msg, buffer, length)) {
        return -EFAULT; // Falha ao copiar do usuário
    }

    msg[length] = '\0'; // Finaliza como string
    msg_size = length;

    printk(KERN_INFO "Escrito %zu bytes: %s\n", length, msg);
    return length;
}

module_init(device_init);
module_exit(device_exit);


MODULE_LICENSE("GPL");
MODULE_AUTHOR("Monitores, Analía e Cezar");
MODULE_DESCRIPTION("Driver de caractere simples");
