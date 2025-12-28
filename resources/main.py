from ncatbot.core import BotClient, BaseMessageEvent
from ncatbot.utils import config
from ncatbot.plugin_system import on_message

# 从配置文件加载配置
try:
    # 配置文件应该已经通过 config.yaml 加载
    # 如果需要手动设置，可以取消注释下面的行
    # config.set_bot_uin("你的机器人QQ号")
    # config.set_root("你的管理员QQ号")
    pass
except Exception as e:
    print(f"配置加载失败: {e}")

bot = BotClient()

@on_message
async def on_message_handler(event: BaseMessageEvent):
    """处理所有消息事件"""
    try:
        msg = event.message

        # 处理群消息
        if event.is_group_msg():
            text_content = msg.filter_text()
            if text_content and text_content[0].text == "测试":
                await event.reply("群聊：前端模式测试成功")
        else:
            # 处理私聊消息
            await event.reply("你好呀! 我是 NcatBot!")
    except Exception as e:
        print(f"消息处理错误: {e}")

# 启动机器人
if __name__ == "__main__":
    bot.run_frontend(debug=True)  # 前台线程启动，返回全局 API（同步友好）

