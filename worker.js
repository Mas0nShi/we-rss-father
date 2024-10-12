async function handleRequest(request) {
  const { pathname } = new URL(request.url);

  if (pathname === '/') {
    return new Response('Coper~', {
      headers: { 'Content-Type': 'text/plain' },
    });
  } else if (pathname === '/auth/active') {
    const jsonResponse = {
      ok: true,
      err: '',
      data: {
        id: '', // LIC_CODE
        email: '', // LIC_EMAIL
        expire: 99999999999,
        lic_expire: 99999999999,
        sign: '', // rsa sign, plaintext: "$LIC_EMAIL|$LIC_CODE|$expire|$lic_expire"
      }
    };

    return new Response(JSON.stringify(jsonResponse), {
      headers: { 'Content-Type': 'application/json' },
    });
  } else {
    return new Response('Not Found path: ' + pathname, { status: 404 });
  }
}

export default {
  async fetch(request, env, ctx) {
    return handleRequest(request);
  },
};