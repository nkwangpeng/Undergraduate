var ad = document.querySelectorAll('.adsbygoogle');
ad = Array.from(ad);
function erase(value) {
    value.style.display = 'none';
}
ad.filter(erase);