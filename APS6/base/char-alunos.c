#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/fs.h>
#include <linux/uaccess.h> // copy_to_user, copy_from_user;

#define DEVICE_NAME "chardevice"
#define BUF_LEN 1024

static int major; // Número major do driver;
static char msg[BUF_LEN] = {0}; // Buffer interno do driver;
static short msg_size = 0;
static int device_open = 0;

// Funções à serem implementadas;
static int device_open_fn(struct inode *, struct file *);
static int device_release_fn(struct inode *, struct file *);
static ssize_t device_read_fn(struct file *, char *, size_t, loff_t *);
static ssize_t device_write_fn(struct file *, const char *, size_t, loff_t *);

// Estrutura de operações;
static struct file_operations fops = {
    .read = device_read_fn,
    .write = device_write_fn,
    .open = device_open_fn,
    .release = device_release_fn,
};

// Função chamada quando o módulo é carregado;
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

// Função chamada quando o módulo é removido;
static void __exit device_exit(void) {
    unregister_chrdev(major, DEVICE_NAME);
    printk(KERN_INFO "Driver removido com sucesso.\n");
}

static int device_open_fn(struct inode *inode, struct file *file) {
    // TODO: Implementar função que lida com abertura do dispositivo
    return 0;
}

static int device_release_fn(struct inode *inode, struct file *file) {
    // TODO: Implementar função que lida com fechamento do dispositivo
    return 0;
}

static ssize_t device_read_fn(struct file *filp, char *buffer, size_t length, loff_t *offset) {
    // TODO: Implementar leitura do buffer interno para o espaço do usuário
    return 0;
}

static ssize_t device_write_fn(struct file *filp, const char *buffer, size_t length, loff_t *offset) {
    // TODO: Implementar escrita do usuário para o buffer interno
    return 0;
}

module_init(device_init);
module_exit(device_exit);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Monitores");
MODULE_DESCRIPTION("Driver de caractere simples: versão para completar");
