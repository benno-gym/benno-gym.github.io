const toggle=document.querySelector('.nav-toggle');
const nav=document.querySelector('#main-nav');
const links=[...document.querySelectorAll('.main-nav a')];
if(toggle&&nav){
  toggle.addEventListener('click',()=>{
    const open=nav.classList.toggle('open');
    toggle.setAttribute('aria-expanded',String(open));
    toggle.textContent=open?'×':'☰';
  });
  links.forEach(link=>link.addEventListener('click',()=>{
    nav.classList.remove('open');
    toggle.setAttribute('aria-expanded','false');
    toggle.textContent='☰';
  }));
}
const sections=[...document.querySelectorAll('main section[id]')];
const byHash=new Map(links.map(a=>[a.getAttribute('href'),a]));
const observer=new IntersectionObserver(entries=>{
  const visible=entries.filter(e=>e.isIntersecting).sort((a,b)=>b.intersectionRatio-a.intersectionRatio)[0];
  if(!visible) return;
  links.forEach(a=>a.removeAttribute('aria-current'));
  const active=byHash.get(`#${visible.target.id}`);
  if(active) active.setAttribute('aria-current','page');
},{rootMargin:'-28% 0px -60% 0px',threshold:[0.12,0.25,0.5]});
sections.forEach(section=>observer.observe(section));
