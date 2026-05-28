# Guia detalhado para preparar um pacote R para publicação no CRAN

## Visão geral

Publicar um pacote no CRAN exige mais do que ter funcionalidades prontas: o pacote precisa estar estável, portável, bem documentado, juridicamente regular e em conformidade com as políticas formais do repositório.[cite:5][cite:23] O ponto de partida mais importante é tratar a submissão como um processo de release, e não como uma continuação do desenvolvimento diário.[cite:10][cite:14]

Na prática, o CRAN espera um pacote que passe em `R CMD check --as-cran`, funcione em múltiplas plataformas, use apenas interfaces públicas, apresente metadados claros e não imponha custo operacional desnecessário aos mantenedores do repositório.[cite:5][cite:12][cite:23] Esse padrão é particularmente importante porque os pacotes são verificados continuamente em diferentes ambientes e versões do R, incluindo versões de desenvolvimento.[cite:5][cite:24]

## Critérios gerais de aceitação

O CRAN espera que o pacote tenha propósito claro, conteúdo não trivial e qualidade suficiente para distribuição pública.[cite:5][cite:23] Pacotes experimentais, incompletos ou com documentação insuficiente tendem a gerar questionamentos ou rejeição, mesmo quando o código principal já funciona.[cite:5][cite:10]

Também é necessário haver um maintainer humano com e-mail válido, indicado no `DESCRIPTION`, apto a responder sobre bugs, licenciamento, manutenção e questões levantadas durante a revisão.[cite:5][cite:12] Além disso, a submissão deve ser feita a partir do source tarball produzido por `R CMD build`, e as verificações precisam recair exatamente sobre esse artefato final.[cite:5][cite:23]

## Estrutura e organização do pacote

A estrutura do pacote deve seguir as convenções do R, com arquivos e diretórios consistentes com o conteúdo distribuído, como `DESCRIPTION`, `NAMESPACE`, `R/`, `man/`, `tests/`, `vignettes/`, `data/`, `src/` e `inst/`, quando aplicáveis.[cite:12] O manual também chama atenção para nomes de arquivos portáveis, evitando diferenças apenas por capitalização, caracteres problemáticos e convenções que possam falhar em Windows ou macOS.[cite:12]

Arquivos binários executáveis não devem ser incluídos no pacote, e conteúdos desnecessários ao uso final devem ser removidos antes do build.[cite:5][cite:12] O tamanho do pacote também importa: materiais muito pesados, especialmente documentação e dados, podem motivar objeções dos mantenedores e exigem justificativa mais forte.[cite:5]

## DESCRIPTION e metadados

O arquivo `DESCRIPTION` é um dos principais pontos de inspeção do CRAN e precisa estar completo e bem escrito.[cite:12][cite:23] Campos como `Package`, `Version`, `Title`, `Description`, `License`, `Maintainer` e `Authors@R` precisam estar corretos, consistentes e semanticamente úteis para quem encontra o pacote pela primeira vez.[cite:12]

O título deve ser curto, descritivo e não redundante com o nome do pacote, enquanto a `Description` deve explicar o que o pacote faz, qual problema resolve e qual abordagem adota, em linguagem objetiva.[cite:12][cite:23] O uso de `Authors@R` é recomendado para explicitar papéis como autor, maintainer e colaborador, além de permitir metadados mais ricos, como ORCID quando apropriado.[cite:12]

## Licença, autoria e direitos

A licença precisa ser explícita e compatível com a distribuição pelo CRAN.[cite:12][cite:5] Declarações vagas ou juridicamente frágeis, como assumir domínio público sem base adequada, não são suficientes para uma submissão robusta.[cite:12]

Todo código, dado, texto, imagem ou outro material de terceiros precisa estar coberto por permissão ou licença compatível, com atribuição correta quando necessária.[cite:5][cite:12] Na prática, isso significa revisar dependências incorporadas, arquivos em `inst/`, datasets distribuídos e qualquer conteúdo copiado de fontes externas antes da submissão.[cite:5]

## Dependências e uso de APIs

Dependências obrigatórias devem ser justificadas, mínimas e corretamente declaradas em `Imports`, `Depends` ou `LinkingTo`, enquanto dependências opcionais devem ser tratadas com tolerância em exemplos, testes e vignettes.[cite:12][cite:5] O CRAN tende a ser mais receptivo a pacotes com árvore de dependência enxuta e comportamento previsível em ambientes limpos.[cite:10]

Também é fundamental usar apenas APIs públicas do R e de outros pacotes.[cite:5][cite:12] O uso de `:::` ou de interfaces internas tende a ser visto como frágil e pode quebrar quando versões futuras alterarem objetos não exportados.[cite:12]

## Código, compilação e portabilidade

O pacote deve funcionar em Linux, Windows e macOS, ou ao menos não conter pressupostos específicos de um único sistema operacional.[cite:5][cite:24] Isso inclui caminhos de arquivo, permissões, codificação, finais de linha, ferramentas de sistema e chamadas externas que possam variar entre plataformas.[cite:12]

Se houver código compilado em C, C++ ou Fortran, é necessário observar as exigências do manual sobre registro de rotinas nativas, uso correto das APIs do R e compatibilidade com o toolchain usado nas máquinas de checagem.[cite:12] O CRAN também rejeita comportamentos que interfiram no processo hospedeiro, como chamadas impróprias de término do R, manipulação invasiva do ambiente ou ações potencialmente inseguras.[cite:5][cite:12]

## Documentação, exemplos e vignettes

Toda função exportada deve ter documentação Rd adequada, com argumentos, valores retornados, detalhes relevantes e exemplos executáveis.[cite:12] A documentação não serve apenas ao usuário final: ela também é inspecionada como evidência de maturidade e consistência do pacote.[cite:10]

Os exemplos precisam ser curtos, reproduzíveis e rápidos, porque podem ser executados durante as checagens automatizadas.[cite:12][cite:14] Vignettes são altamente recomendadas quando o pacote possui fluxo de uso mais complexo, mas também precisam evitar tempo excessivo, dependências frágeis e uso imprevisível de rede ou recursos externos.[cite:12][cite:5]

## Testes e qualidade antes da submissão

Antes de submeter, o pacote deve ser construído com `R CMD build` e validado com `R CMD check --as-cran` no artefato gerado.[cite:5][cite:23] O objetivo prático é eliminar erros e warnings e reduzir notes ao estritamente justificável, porque notes aparentemente pequenos costumam desencadear perguntas dos revisores.[cite:23][cite:14]

Além da checagem local, vale executar verificações em R release e R-devel, preferencialmente em mais de um sistema operacional.[cite:10][cite:24] O serviço win-builder é especialmente útil para antecipar problemas em Windows e em versões de desenvolvimento do R sem depender de infraestrutura própria.[cite:24]

## Atualizações e dependências reversas

Quando o pacote já está publicado ou já possui usuários no ecossistema, mudanças de API, comportamento ou assinatura podem afetar pacotes dependentes.[cite:10][cite:16] Por isso, é recomendável rodar verificações de reverse dependencies antes de submissões que alterem interface pública ou semântica de funções importantes.[cite:10]

Esse cuidado é particularmente relevante em updates para o CRAN, porque uma alteração que passa nos testes locais ainda pode quebrar outros pacotes a jusante.[cite:16] Se houver risco de impacto, convém registrar isso na mensagem de submissão e, quando aplicável, comunicar mantenedores afetados.[cite:5]

## Processo de submissão

A submissão deve ser feita pelo formulário oficial do CRAN, com o source tarball final e uma mensagem objetiva explicando o contexto da submissão.[cite:5][cite:23] Em novos pacotes, essa mensagem normalmente inclui uma descrição breve do propósito do pacote e eventuais notas sobre dependências, dados grandes, notas residuais ou necessidades especiais.[cite:23]

Depois do envio, é necessário confirmar o e-mail de submissão e aguardar o retorno dos mantenedores.[cite:5] Reenvios repetidos da mesma versão, respostas vagas ou correções parciais tendem a piorar a interação com a revisão, então a estratégia correta é responder ponto a ponto e subir uma nova versão apenas quando os problemas estiverem realmente resolvidos.[cite:5][cite:10]

## Riscos mais comuns que atrasam aprovação

Os problemas mais recorrentes incluem `DESCRIPTION` fraco, exemplos lentos, documentação incompleta, dependências excessivas, notas ignoradas, testes frágeis e comportamento não portátil.[cite:23][cite:14] Outro motivo frequente de retrabalho é submeter sem testar em ambientes suficientemente próximos dos do CRAN, especialmente sem considerar `R-devel` e Windows.[cite:24][cite:10]

Também geram fricção itens como uso de rede durante checks, escrita fora de diretórios temporários, arquivos grandes, código que acessa internals e respostas pouco precisas aos e-mails dos mantenedores.[cite:5][cite:12] Em geral, o pacote é melhor recebido quando demonstra previsibilidade operacional e baixo custo de manutenção para o ecossistema.[cite:5]

## Checklist operacional para a equipe de desenvolvimento

### 1. Metadados e identidade

- Confirmar que `Package`, `Version`, `Title`, `Description`, `License`, `Maintainer` e `Authors@R` estão completos e corretos.[cite:12]
- Revisar o `Title` para remover redundância com o nome do pacote e evitar marketing ou linguagem promocional.[cite:23]
- Reescrever a `Description` como um parágrafo objetivo, explicando finalidade, escopo e diferencial do pacote.[cite:12][cite:23]
- Validar nome do pacote contra conflitos e similaridade excessiva com pacotes já existentes no CRAN.[cite:5]

### 2. Estrutura do repositório

- Verificar se os diretórios do pacote seguem a convenção padrão do R e contêm apenas arquivos necessários à distribuição.[cite:12]
- Remover arquivos temporários, binários, caches locais, resultados intermediários e material irrelevante ao usuário final.[cite:5][cite:12]
- Conferir se nomes de arquivos são portáveis entre Linux, Windows e macOS.[cite:12]

### 3. Licença e compliance

- Confirmar que a licença declarada é válida e coerente com o conteúdo distribuído.[cite:12]
- Auditar código e dados de terceiros incorporados ao pacote, com checagem de permissões e atribuições.[cite:5]
- Verificar se datasets, imagens, textos ou modelos embarcados têm base legal de redistribuição.[cite:5]

### 4. Dependências

- Reduzir dependências obrigatórias ao mínimo necessário.[cite:10][cite:12]
- Mover dependências não essenciais para `Suggests`, quando tecnicamente viável.[cite:12]
- Revisar exemplos, testes e vignettes para que falhem graciosamente quando dependências opcionais não estiverem instaladas.[cite:12]
- Eliminar uso de `:::` e de funções internas de pacotes terceiros.[cite:12][cite:5]

### 5. Qualidade do código

- Revisar mensagens de erro, warnings e comportamento de edge cases nas funções exportadas.[cite:10]
- Garantir que o pacote não escreva em locais indevidos, não dependa de estado global e não faça chamadas inseguras ao sistema.[cite:5][cite:12]
- Se houver código compilado, validar registro de rotinas nativas e compatibilidade com toolchains suportados.[cite:12]

### 6. Documentação

- Garantir documentação Rd completa para todas as funções exportadas.[cite:12]
- Revisar exemplos para execução rápida, determinística e sem dependência frágil de rede.[cite:12][cite:5]
- Incluir vignette quando o fluxo de uso exigir tutorial ou narrativa mais longa.[cite:12]
- Revisar README para alinhar instalação, exemplos e posicionamento do pacote com o estado real do código.[cite:10]

### 7. Testes

- Executar suite de testes automatizados em ambiente limpo.[cite:10]
- Confirmar cobertura funcional mínima para API pública e principais casos de erro.[cite:10]
- Rodar `R CMD build` seguido de `R CMD check --as-cran` no tarball final.[cite:23][cite:5]
- Tratar erros e warnings como bloqueadores e justificar qualquer note residual antes da submissão.[cite:23]

### 8. Portabilidade

- Testar em R release e R-devel.[cite:10][cite:24]
- Validar o pacote em pelo menos dois sistemas operacionais; usar win-builder quando necessário para Windows.[cite:24]
- Revisar encoding, caminhos, separadores e dependências de sistema que possam variar entre plataformas.[cite:12]

### 9. Atualizações e impacto no ecossistema

- Mapear reverse dependencies antes de alterações de API ou comportamento.[cite:10][cite:16]
- Executar checks em pacotes dependentes, quando existirem.[cite:16]
- Registrar mudanças breaking no `NEWS` e na mensagem de submissão.[cite:5][cite:10]

### 10. Submissão

- Gerar o source tarball final com `R CMD build`.[cite:23]
- Submeter pelo formulário oficial do CRAN com comentário objetivo e técnico.[cite:5][cite:23]
- Confirmar o e-mail de submissão e acompanhar o retorno dos mantenedores.[cite:5]
- Em caso de revisão, responder item por item e reenviar apenas com nova versão corrigida.[cite:5]

## Sequência recomendada de trabalho

Uma ordem eficiente para reduzir retrabalho é começar por `DESCRIPTION`, licença e estrutura do pacote; em seguida, estabilizar documentação, exemplos e testes; depois, atacar portabilidade e checks em múltiplos ambientes; por fim, preparar a submissão com tarball final e mensagem técnica concisa.[cite:23][cite:10] Essa sequência funciona bem porque muitos problemas de revisão surgem antes mesmo de aspectos mais profundos do código, especialmente em metadados, documentação e conformidade básica.[cite:5][cite:14]

Em equipes, vale tratar essa preparação como uma mini-release checklist, com responsável por compliance, responsável por documentação e responsável por validação multiplataforma.[cite:10] Esse tipo de divisão reduz risco de submissão prematura e melhora a qualidade da resposta ao CRAN quando surgem questionamentos.[cite:5]

## Comandos úteis para validação final

```r
# Gerar documentação e metadados
roxygen2::roxygenise()

# Rodar testes
 testthat::test_dir("tests/testthat")

# Build do pacote
system("R CMD build .")

# Check no tarball gerado
system("R CMD check --as-cran pacote_versao.tar.gz")
```

Esses comandos ajudam a padronizar a etapa final, mas o ponto crítico continua sendo revisar o resultado do `check` e não apenas executá-lo.[cite:23][cite:10] Em pacotes mais sensíveis a plataforma, também convém complementar essa rotina com validação no win-builder e em R-devel antes do envio oficial.[cite:24]
