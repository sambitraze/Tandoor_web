#include <stdio.h>
#include <stdlib.h>
struct Node
{
    int data;
    struct Node *next;

} *front = NULL, *rear = NULL;
void insert()
{
    int x;
    printf("Enter the element\n");
    scanf("%d",&x);
    struct Node *t;
    t = (struct Node *)malloc(sizeof(struct Node));
    if (t == NULL)
        printf("Queue Overflow\n");
    else
    {
        t->data = x;
        t->next = NULL;
        if (front == NULL)
            front = rear = t;
        else
        {
            rear->next = t;
            rear = t;
        }
    }
}
int delete()
{
    int x = -1;
    struct Node *t;

    if (front == NULL)
        printf("Queue Underflow");
    else
    {
        x = front->data;
        t = front;
        front = front->next;
        free(t);
    }
    return x;
}
void display()
{
    struct Node *p = front;
    while (p)
    {
        printf("%d ", p->data);
        p = p->next;
    }
    printf("\n");
}
int main()
{
    int n;
    printf("Enter the number of elements to be inserted:\n");
    scanf("%d", &n);
    int choice;
    while (1)
    {
        printf("1.Insert element to queue \n");
        printf("2.Delete element from queue \n");
        printf("3.Display all elements of queue \n");
        printf("4.Quit \n");
        printf("Enter your choice : ");
        scanf("%d", &choice);
        switch (choice)
        {
        case 1:
            insert();
            break;
        case 2:
            delete ();
            break;
        case 3:
            display();
            break;
        case 4:            
            exit(1);
        default:
            printf("invalid choice \n");
        } 
    }    
    return 0;
}