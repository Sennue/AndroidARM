#include <stdio.h>
#include <sys/syscall.h>
#include <unistd.h>

#define BUFFER_SIZE  2048
#define MESSAGE      "Args: [C]\n"

char buffer[BUFFER_SIZE];

const char message[] = MESSAGE;
const int  length    = sizeof MESSAGE - 1; // sizeof inclues \0

int main(int argc, char** argv)
{
  // write message
  syscall(SYS_write, STDOUT_FILENO, message, length);

  // loop over argv until argvn_ptr is null
  char *argvn_ptr = *(argv++);
  while (NULL != argvn_ptr) {
    char *buffer_ptr = buffer;
    // copy from argvn_ptr to buffer_ptr until \0 is encountered
    while ('\0' != *argvn_ptr) {
      *(buffer_ptr++) = *(argvn_ptr++);
    }
    // append \n and write buffer
    *buffer_ptr++ = '\n';
    syscall(SYS_write, STDOUT_FILENO, buffer, buffer_ptr - buffer);
    // next arg
    argvn_ptr = *(argv++);
  }
  // done
  syscall(SYS_exit, 0);
}
