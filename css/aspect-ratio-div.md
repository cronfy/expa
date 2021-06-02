```css
/* source: https://css-tricks.com/aspect-ratio-boxes/ */

.aspect-ratio-box {
  height: 0;
  overflow: hidden;
    padding-top: calc(9 / 16 * 100%); /* 16:9 (horizontal) */ 
  background: white;
  position: relative;
}
.aspect-ratio-box-inside {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
}
```
