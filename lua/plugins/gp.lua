-- ============================================================================
-- gp.nvim — Blog Writing Assistant (Qwen Plus via DashScope)
-- ============================================================================
-- Place this file at: ~/.config/nvim/lua/plugins/gp-writing.lua
--
-- Environment variable needed (add to .bashrc / .zshrc):
--   export DASHSCOPE_API_KEY="sk-xxx"   # 阿里云百炼 API Key
--
-- Quick Reference (all work in Visual mode):
--   <leader>we  — 中 → 英 (replace in place)
--   <leader>wE  — 中 → 英 (detailed, translation notes → new split)
--   <leader>wc  — 英 → 中 (replace in place)
--   <leader>wC  — 英 → 中 (detailed → new split)
--   <leader>wp  — 英文润色 (replace in place)
--   <leader>wP  — 英文润色 (detailed, modification log → new split)
--   <leader>wg  — Grammar fix only
--   <leader>wf  — Free rewrite (enter custom instructions)
--   <leader>wt  — Open writing chat (interactive)
--   <leader>ws  — Stop generation
-- ============================================================================

-- ---------------------------------------------------------------------------
-- Model config
-- ---------------------------------------------------------------------------
local model_translate = { model = "qwen-plus", temperature = 0.7 }
local model_polish = { model = "qwen-plus", temperature = 0.6 }

-- ---------------------------------------------------------------------------
-- System Prompts
-- ---------------------------------------------------------------------------

local prompt_zh_to_en = [[
You are a bilingual Chinese-English writing assistant, well-versed in the style of international tech blogs (engineering blogs, personal tech sites), and equally comfortable with casual, everyday content.

Core rules:
1. Style & Tone:
   - Preserve the author's personal voice. Don't flatten it into dry, impersonal prose.
   - For technical content, match the tone of international engineering blogs: clear, direct, opinionated, concise.
   - For casual/life content, keep it relaxed and natural — like a real person talking.
   - Contractions are fine (it's, don't, let's) — this is a blog, not a paper.

2. Technical content:
   - Keep math formulas as-is (preserve `$...$` and `$$...$$` LaTeX syntax).
   - Keep technical terms accurate. Don't sacrifice precision for accessibility.
   - Keep code blocks and command lines exactly as they are.

3. Logic & Readability:
   - Preserve the core arguments and reasoning, but adjust sentence order to fit natural English reading flow.
   - If the original has logical gaps, you may add a brief transition — but don't over-explain.

4. Format:
   - Preserve paragraph structure, subheadings, and list formatting (Markdown).
]]

local prompt_en_to_zh = [[
You are a bilingual Chinese-English writing assistant who excels at translating English into natural, idiomatic Chinese. You have zero tolerance for "translationese" — the moment you see phrases like "据悉", "鉴于此", or "值得注意的是", you cringe.

Core rules:
1. Translation principles:
   - Strictly match the original meaning, but express it the way a native Chinese speaker would naturally read and write.
   - Reject translationese: avoid stiff expressions like "在某种程度上", "就...而言", "这一点至关重要". Write like a normal person talks.
   - Keep technical terms in English (e.g., API, Docker, LLM, Transformer). Don't force-translate them.

2. Technical content:
   - Keep math formulas as-is (preserve `$...$` and `$$...$$` LaTeX syntax).
   - Keep code blocks and command lines exactly as they are.

3. Style:
   - Match the original tone: casual stays casual, serious stays serious.

4. Format:
   - Preserve paragraph structure, subheadings, and list formatting (Markdown).
]]

local prompt_polish = [[
You are a native-level English blog editor who has spent years polishing posts for popular writers on Medium, Substack, and similar platforms. You don't chase "correct" English — you chase "readable" English: good rhythm, precise word choices, the kind of writing people actually want to read.

Core rules:
1. Expression optimization (your main job):
   - Eliminate non-native writing artifacts: fix awkward sentence structures, unnatural collocations, and stiff phrasing.
   - Polish the rhythm: alternate between long and short sentences. Avoid consecutive sentences with identical structures. Good blog writing breathes.
   - Zero errors: fix all spelling, grammar, and punctuation mistakes.

2. Vocabulary & Tone:
   - Choose the most precise word, not the fanciest one.
   - Contractions are OK (it's, don't, can't) — blogs aren't academic papers.
   - Preserve the author's original tone — if the original is humorous, keep it humorous; if serious, keep it serious.

3. Content integrity:
   - Do NOT change the original viewpoints, arguments, or reasoning.
   - Do NOT delete or add substantive content.
   - Preserve the original formatting structure.
]]

-- ---------------------------------------------------------------------------
-- Plugin Spec (lazy.nvim)
-- ---------------------------------------------------------------------------
return {
	"robitx/gp.nvim",
	event = "VeryLazy",
	config = function()
		local gp = require("gp")

		gp.setup({
			-- =============================================================
			-- Provider
			-- =============================================================
			providers = {
				qwen = {
					endpoint = "https://dashscope.aliyuncs.com/compatible-mode/v1/chat/completions",
					secret = os.getenv("DASHSCOPE_API_KEY"),
				},
			},

			-- =============================================================
			-- Agents
			-- =============================================================
			agents = {
				-- Disable all built-in agents
				{ name = "ChatGPT4o", disable = true },
				{ name = "ChatGPT4o-mini", disable = true },
				{ name = "ChatGPT-o3-mini", disable = true },
				{ name = "ChatCopilot", disable = true },
				{ name = "ChatGemini", disable = true },
				{ name = "ChatPerplexityLlama3.1-8B", disable = true },
				{ name = "ChatOllamaLlama3.1-8B", disable = true },
				{ name = "ChatLMStudio", disable = true },
				{ name = "ChatQwen3-8B", disable = true },
				{ name = "ChatClaude-3-7-Sonnet", disable = true },
				{ name = "ChatClaude-3-5-Haiku", disable = true },
				{ name = "ChatClaude-Sonnet-4-Thinking", disable = true },
				{ name = "CodeGPT4o", disable = true },
				{ name = "CodeGPT4o-mini", disable = true },
				{ name = "CodeGPT-o3-mini", disable = true },
				{ name = "CodeCopilot", disable = true },
				{ name = "CodeGemini", disable = true },
				{ name = "CodePerplexityLlama3.1-8B", disable = true },
				{ name = "CodeOllamaLlama3.1-8B", disable = true },
				{ name = "CodeClaude-3-7-Sonnet", disable = true },
				{ name = "CodeClaude-3-5-Haiku", disable = true },

				-- ── Writing Agents ─────────────────────────────
				{
					provider = "qwen",
					name = "BlogZhToEn",
					chat = false,
					command = true,
					model = model_translate,
					system_prompt = prompt_zh_to_en,
				},
				{
					provider = "qwen",
					name = "BlogEnToZh",
					chat = false,
					command = true,
					model = model_translate,
					system_prompt = prompt_en_to_zh,
				},
				{
					provider = "qwen",
					name = "BlogPolish",
					chat = false,
					command = true,
					model = model_polish,
					system_prompt = prompt_polish,
				},
				{
					provider = "qwen",
					name = "WritingChat",
					chat = true,
					command = false,
					model = model_translate,
					system_prompt = "You are a bilingual Chinese-English writing assistant.\n"
						.. "Help the user with translation, proofreading, word choice, and expression.\n"
						.. "Be concise. Provide alternatives when there are multiple good options.\n"
						.. "If the user writes in Chinese, translate and polish into natural English.\n"
						.. "If the user writes in English, help refine the expression.\n"
						.. "Always preserve Markdown formatting, code blocks, and LaTeX math.\n",
				},
				{
					provider = "qwen",
					name = "GeneralCmd",
					chat = false,
					command = true,
					model = model_translate,
					system_prompt = "You are a helpful assistant. Follow the user's instructions precisely. "
						.. "Respond only with the requested content, no extra commentary.",
				},
			},

			-- =============================================================
			-- Chat Settings
			-- =============================================================
			default_chat_agent = "WritingChat",
			default_command_agent = "GeneralCmd",
			toggle_target = "vsplit",

			template_selection = "{{selection}}\n\n{{command}}",
			template_rewrite = "{{selection}}\n\n{{command}}"
				.. "\n\nRespond exclusively with the text that should replace the selection above."
				.. " Do NOT include any explanations, notes, or extra commentary."
				.. " Output ONLY the replacement text.",
			template_append = "{{selection}}\n\n{{command}}"
				.. "\n\nRespond exclusively with the text that should be appended after the selection above.",
			template_prepend = "{{selection}}\n\n{{command}}"
				.. "\n\nRespond exclusively with the text that should be prepended before the selection above.",

			-- =============================================================
			-- Hooks
			-- =============================================================
			hooks = {

				ZhToEn = function(gp_mod, params)
					local agent = gp_mod.get_command_agent("BlogZhToEn")
					local template = "{{selection}}\n\n"
						.. "Translate the Chinese text above into natural, conversational English "
						.. "suitable for a tech blog post.\n\n"
						.. "Rules:\n"
						.. "- Output ONLY the English translation, nothing else.\n"
						.. "- No explanations, no notes, no Part 1/Part 2 labels.\n"
						.. "- Preserve all Markdown formatting, code blocks, and LaTeX math.\n"
						.. "- Use contractions (it's, don't) for natural blog tone."
					gp_mod.Prompt(params, gp_mod.Target.rewrite, agent, template)
				end,

				ZhToEnDetailed = function(gp_mod, params)
					local agent = gp_mod.get_command_agent("BlogZhToEn")
					local template = "{{selection}}\n\n"
						.. "Translate the Chinese blog draft above into an English blog post.\n\n"
						.. "Output format (follow strictly):\n"
						.. "## English\n\n[Your translated English blog text here]\n\n"
						.. "## Translation Notes\n\n"
						.. "[Brief notes on translation choices: how you handled specific expressions, "
						.. "sentence reordering decisions, etc. Write notes in Chinese.]\n\n"
						.. "Rules:\n"
						.. "- Preserve Markdown formatting, code blocks, and LaTeX math.\n"
						.. "- Use contractions (it's, don't) for natural blog tone.\n"
						.. "- Match the original tone: technical → clear & direct; casual → relaxed & natural."
					gp_mod.Prompt(params, gp_mod.Target.vnew("markdown"), agent, template)
				end,

				EnToZh = function(gp_mod, params)
					local agent = gp_mod.get_command_agent("BlogEnToZh")
					local template = "{{selection}}\n\n"
						.. "Translate the English text above into natural, idiomatic Chinese.\n\n"
						.. "Rules:\n"
						.. "- Output ONLY the Chinese translation, nothing else.\n"
						.. "- No explanations, no notes.\n"
						.. "- Zero translationese. Write like a native Chinese speaker.\n"
						.. "- Keep technical terms in English (API, Docker, LLM, etc.).\n"
						.. "- Preserve all Markdown formatting, code blocks, and LaTeX math."
					gp_mod.Prompt(params, gp_mod.Target.rewrite, agent, template)
				end,

				EnToZhDetailed = function(gp_mod, params)
					local agent = gp_mod.get_command_agent("BlogEnToZh")
					local template = "{{selection}}\n\n"
						.. "Translate the English text above into natural, idiomatic Chinese.\n\n"
						.. "Rules:\n"
						.. "- Zero translationese. Write like a native Chinese speaker.\n"
						.. "- Keep technical terms in English (API, Docker, LLM, etc.).\n"
						.. "- Preserve all Markdown formatting, code blocks, and LaTeX math.\n"
						.. "- Output only the translated Chinese text."
					gp_mod.Prompt(params, gp_mod.Target.vnew("markdown"), agent, template)
				end,

				Polish = function(gp_mod, params)
					local agent = gp_mod.get_command_agent("BlogPolish")
					local template = "{{selection}}\n\n"
						.. "Polish the English blog text above to native-level quality.\n\n"
						.. "Rules:\n"
						.. "- Output ONLY the polished English text, nothing else.\n"
						.. "- No explanations, no notes, no Part 1/2/3 labels.\n"
						.. "- Fix grammar, improve rhythm, eliminate non-native phrasing.\n"
						.. "- Preserve the author's original tone and meaning.\n"
						.. "- Preserve all Markdown formatting, code blocks, and LaTeX math."
					gp_mod.Prompt(params, gp_mod.Target.rewrite, agent, template)
				end,

				PolishDetailed = function(gp_mod, params)
					local agent = gp_mod.get_command_agent("BlogPolish")
					local template = "{{selection}}\n\n"
						.. "Polish the English blog text above to native-level quality.\n\n"
						.. "Output format (follow strictly):\n"
						.. "## Polished\n\n[Polished English blog text here]\n\n"
						.. "## 中文对照翻译\n\n"
						.. "[Chinese translation of the polished version, "
						.. "so the author can verify the polished text didn't drift from the original meaning.]\n\n"
						.. "## 修改说明\n\n"
						.. "[Brief notes IN CHINESE on what you changed and why: "
						.. "specific phrasing fixes, rhythm adjustments, word choice decisions, etc.]\n\n"
						.. "Rules:\n"
						.. "- Fix grammar, improve rhythm, eliminate non-native phrasing.\n"
						.. "- Preserve the author's original tone and meaning.\n"
						.. "- Preserve all Markdown formatting, code blocks, and LaTeX math."
					gp_mod.Prompt(params, gp_mod.Target.vnew("markdown"), agent, template)
				end,

				GrammarFix = function(gp_mod, params)
					local agent = gp_mod.get_command_agent("BlogPolish")
					local template = "{{selection}}\n\n"
						.. "Fix ONLY grammar, spelling, and punctuation errors in the text above.\n"
						.. "Do NOT change word choice, sentence structure, or tone.\n"
						.. "Output ONLY the corrected text, nothing else."
					gp_mod.Prompt(params, gp_mod.Target.rewrite, agent, template)
				end,

				FreeRewrite = function(gp_mod, params)
					local agent = gp_mod.get_command_agent("GeneralCmd")
					gp_mod.Prompt(params, gp_mod.Target.rewrite, agent, nil, "🖊️  rewrite instructions ~ ")
				end,

				WritingChat = function(gp_mod, params)
					local chat_system_prompt = "You are a bilingual Chinese-English writing assistant.\n"
						.. "The user is writing a blog. Help with translation, word choice, "
						.. "tone adjustment, and expression polishing.\n"
						.. "Be concise and practical. Provide alternatives when appropriate.\n"
						.. "Preserve all Markdown formatting, code blocks, and LaTeX math."
					gp_mod.cmd.ChatNew(params, chat_system_prompt)
				end,
			},

			whisper = { disable = true },
			image = { disable = true },
		})

		-- =============================================================
		-- Keymaps
		-- =============================================================
		local km = vim.keymap.set
		local opts = function(desc)
			return { noremap = true, silent = true, nowait = true, desc = "Writing: " .. desc }
		end

		km("v", "<leader>we", ":<C-u>'<,'>GpZhToEn<CR>", opts("中→英 translate"))
		km("v", "<leader>wc", ":<C-u>'<,'>GpEnToZh<CR>", opts("英→中 translate"))
		km("v", "<leader>wp", ":<C-u>'<,'>GpPolish<CR>", opts("English polish"))
		km("v", "<leader>wg", ":<C-u>'<,'>GpGrammarFix<CR>", opts("Grammar fix only"))
		km("v", "<leader>wf", ":<C-u>'<,'>GpFreeRewrite<CR>", opts("Free rewrite"))

		km("v", "<leader>wE", ":<C-u>'<,'>GpZhToEnDetailed<CR>", opts("中→英 detailed"))
		km("v", "<leader>wC", ":<C-u>'<,'>GpEnToZhDetailed<CR>", opts("英→中 detailed"))
		km("v", "<leader>wP", ":<C-u>'<,'>GpPolishDetailed<CR>", opts("English polish detailed"))

		km({ "n", "v" }, "<leader>wt", "<cmd>GpWritingChat<CR>", opts("Writing chat"))
		km({ "n", "v" }, "<leader>ws", "<cmd>GpStop<CR>", opts("Stop generation"))

		km("n", "<leader>we", "<cmd>GpZhToEn<CR>", opts("中→英 current line"))
		km("n", "<leader>wc", "<cmd>GpEnToZh<CR>", opts("英→中 current line"))
		km("n", "<leader>wp", "<cmd>GpPolish<CR>", opts("Polish current line"))
		km("n", "<leader>wg", "<cmd>GpGrammarFix<CR>", opts("Grammar fix current line"))
	end,
}
