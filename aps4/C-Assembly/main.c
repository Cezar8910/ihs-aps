#include <stdio.h>

extern float calc_cone_volume(float raio, float altura);

int main() {
    float r = 3.0;
    float h = 5.0;

    float volume = calc_cone_volume(r, h);

    printf("Volume do cone de raio %.2f e altura %.2f = %.2f\n", r, h, volume);

    return 0;
}
