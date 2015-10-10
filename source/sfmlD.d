module baka.sfmlD;
import derelict.sfml2.window;
import derelict.sfml2.system;
import derelict.sfml2.graphics;
import derelict.sfml2.audio;

import std.conv;
import std.string:toStringz;
import std.utf:toUTFz;

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
//■
//■ sfGameWindow
//■
//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
class GameWindow{
	sfRenderWindow* gameWindow;
	
	this( string title, int w, int h ){
		DerelictSFML2Window.load();
		DerelictSFML2System.load();
		DerelictSFML2Graphics.load();
		DerelictSFML2Audio.load();

		this.gameWindow = sfRenderWindow_createUnicode (
			sfVideoMode( w, h ),
			toUTFz!(dchar*)(title),
			sfClose, null);
	}
	
	// 클리어
	void clear( sfColor color=sfBlack ){
		sfRenderWindow_clear( this.gameWindow, color );
	}
	
	// 디스플레이
	void display(){
		sfRenderWindow_display( this.gameWindow );
	}
	
	// 열려 있는가?
	sfBool isOpen(){
		return( sfRenderWindow_isOpen(this.gameWindow) );
	}
	
	// 닫기
	void close(){
		sfRenderWindow_close( this.gameWindow );
	}
	
	// 파괴
	void destroy(){
		sfRenderWindow_destroy( this.gameWindow );
	}
	
	// 텍스처(Texture) 그리기
	void draw( Texture textureObject ){
		sfRenderWindow_drawRectangleShape( this.gameWindow, textureObject.shape, null );
	}
	
	// 텍스트(Text) 그리기
	void draw( Text textObject ){
		sfRenderWindow_drawText( this.gameWindow, textObject.text, null );
	}
	
	// 스프라이트(Sprite) 그리기
	void draw( Sprite spriteObject ){
		sfRenderWindow_drawSprite( this.gameWindow, spriteObject.sprite , null);
	}
	
	sfBool pollEvent( sfEvent* e ){
		return( sfRenderWindow_pollEvent(this.gameWindow, e) );
	}
}



//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
//■
//■ sfSprite
//■
//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
class Sprite{
	sfSprite* sprite;
	this(){
		this.sprite = sfSprite_create();
	}
}



//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
//■
//■ sfTexture
//■
//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
class Texture{
	// 텍스처와 도형
	sfTexture* texture;
	sfRectangleShape* shape;
	
	//생성자
	this( string fileName ){
		DerelictSFML2Window.load();
		DerelictSFML2Graphics.load();
		DerelictSFML2System.load();
		
		// 텍스처 로드
		this.texture = sfTexture_createFromFile( toStringz(fileName), null );
		
		// 도형 로드
		this.shape = sfRectangleShape_create();
		
		// 텍스처 이미지의 크기 얻기
		auto sizeOriginal = sfTexture_getSize(this.texture);
		
		// 쉐이프 크기와 텍스처 크기 동기화
		sfRectangleShape_setSize(
			this.shape,
			sfVector2f( cast(float)sizeOriginal.x, cast(float)sizeOriginal.y )
		);
		
		// 쉐이프에 텍스처 연결
		sfRectangleShape_setTexture( this.shape, this.texture, sfTrue);
	}
	
	/*
	 * 그려질 위치 설정
	 */
	void setPosition( int x, int y ){
		sfRectangleShape_setPosition( shape, sfVector2f( cast(float)x, cast(float)y) );
	}
}

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
//■
//■ sfText
//■
//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
class Text{
	sfText* text;
	
	// 생성자
	this(){
		this.text = sfText_create();
		this.setColor(sfBlack);
		sfText_setPosition( this.text, sfVector2f(10,10) );
	}
	
	// 생성자: + 문자열
	this( string stringObject ){
		this.text = sfText_create();
		this.setUnicodeString( stringObject );
		this.setColor(sfBlack);
	}
	
	// 생성자: + 문자열, 폰트
	this( string stringObject, Font fontObject ){
		this.text = sfText_create();
		this.setUnicodeString( stringObject );
		this.setFont( fontObject );
		this.setColor( sfBlack );
	}
	
	// d문자열 설정
	void setString( string text ){
		sfText_setString( this.text,  toStringz(text) );
		this.setCharacterSize( 10 );
	}
	
	// 유니코드 문자열 설정
	void setUnicodeString( string stringObject ){
		const dchar* data = toUTFz!(dchar*)(stringObject);
		sfText_setUnicodeString( this.text, data );
	}
	
	// 문자 크기 설정
	void setCharacterSize( uint size ){
		sfText_setCharacterSize( this.text, size );
	}
	
	// 폰트 설정
	void setFont( Font fontObject ){
		sfText_setFont( this.text, fontObject.font );
	}
	
	// 색상 설정
	void setColor( sfColor color ){
		sfText_setColor(this.text, color);
	}
	
	// 그려질 위치 설정
	void setPosition( int x, int y ){
		sfText_setPosition( this.text, sfVector2f(x,y) );
	}
}

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
//■
//■ sfFont
//■
//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
class Font{
	sfFont* font;
	
	// 생성자
	this( string fileName ){
		this.font = sfFont_createFromFile( toStringz(fileName) );
	}
	
	auto getGlyph( uint codePoint, uint characterSize, sfBool bold ){
		return (sfFont_getGlyph( this.font, codePoint, characterSize, bold) );

	}
}

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
//■
//■ sfMusic
//■
//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
class Music{
	sfMusic* music;
	
	// 생성자
	this( string fileName ){
		this.music = sfMusic_createFromFile( toStringz(fileName) );
	}
	
	
	// 파괴
	void destory(){
		sfMusic_destroy( this.music );
	}
	
	// 반복설정 하기
	void setLoop( bool isLoop ){
		sfMusic_setLoop( this.music, isLoop );
	}
	
	// 반복설정 값 가져오기
	int getLoop(){
		return( sfMusic_getLoop( this.music ) );	
	}
	
	// 듀레이션 얻기
	sfTime getDuration(){
		return( sfMusic_getDuration(this.music) );
	}
	
	// 재생
	void play(){
		sfMusic_play( this.music );
	}
	
	// 일시중지
	void pause(){
		sfMusic_pause( this.music );
	}
	
	// 정지
	void stop(){
		sfMusic_stop( this.music );
	}
	
	// 채널 카운트 얻기
	uint getChannelCount(){
		return( sfMusic_getChannelCount(this.music) );
	}
	
	// 샘플레이트 얻기
	uint getSampleRate(){
		return( sfMusic_getSampleRate(this.music) );
	}
	
	
	// 상태 얻기
	sfSoundStatus getStatus(){
		return( sfMusic_getStatus(this.music) );
	}
	
	// 재생 오프셋 얻기
	sfTime getPlayingOffset(){
		return( sfMusic_getPlayingOffset(this.music) );
	}
	
	// 피치 설정
	void setPitch( float pitch ){
		sfMusic_setPitch( this.music, pitch );
	}
	
	// 볼륨 설정
	void setVolume( float volume ){
		sfMusic_setVolume( this.music, volume );
	}
	
	// 포지션 설정
	void setPosition( sfVector3f position ){
		sfMusic_setPosition(this.music, position );
	}
	
	// 관계 리스너 설정
	void setRelativeToListener( bool relative ){
		sfMusic_setRelativeToListener( this.music, relative );
	}
	
	// 최소 인스턴스 설정
	void setMinDistance( float distance ){
		sfMusic_setMinDistance( this.music, distance );
	}
	
	// Attenuation 설정
	void setAttenuation( float attenuation ){
		sfMusic_setAttenuation( this.music, attenuation );
	}
	
	// 재생 오프셋 설정
	void setPlayingOffset( sfTime timeOffset ){
		sfMusic_setPlayingOffset( this.music, timeOffset );
	}
	
	// 피치 얻기
	float getPitch(){
		return( sfMusic_getPitch( this.music ) );
	}
	
	// 볼륨 얻기
	float getVolume(){
		return( sfMusic_getVolume( this.music ) );
	}
	
	// 포지션 얻기
	sfVector3f getPosition(){
		return( sfMusic_getPosition( this.music ) );
	}
	
	// 관계 리스너 확인
	int isRelativeToListener(){
		return( sfMusic_isRelativeToListener(this.music) );
	}
	
	// 최소 듀레이션 얻기
	float getMinDistance(){
		return( sfMusic_getMinDistance(this.music) );
	}
	
	// 아몰랑
	float getAttenuation(){
		return( sfMusic_getAttenuation(this.music) );
	}
}



//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
//■
//■ sfClock: 클럭 바인딩
//■
//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
class Clock{
	sfClock* clock;
	// 생성자
	this(){
		this.clock = sfClock_create();
	}
	
	// getEpapsedTime 바인딩
	sfTime getElapsedTime(){
		return( sfClock_getElapsedTime(this.clock) );
	}
	
	sfTime restart(){
		return( sfClock_restart(this.clock) );
	}
}



//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
//■
//■ sfTime: Time 관련 함수
//■
//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
class Time{
	sfTime timeObject;
	float asSeconds(){
		return( sfTime_asSeconds(this.timeObject) );
	}
	
	sfInt32 asMilliseconds(){
		return( sfTime_asMilliseconds(this.timeObject) );
	}
	
	sfInt64 asMicroseconds(){
		return( sfTime_asMicroseconds(this.timeObject) );
	} 

}



//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
//■
//■ sfSound
//■
//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
class Sound{
	sfSound* sound;
	
	this(){
		this.sound = sfSound_create();
	}
	
	this( SoundBuffer soundfBufferObject ){
		this.sound = sfSound_create();
		sfSound_setBuffer( this.sound, soundfBufferObject.soundfBufferObject );
	}
	
	// 파괴
	void destory(){
		sfSound_destroy( this.sound );
	}
	
	// 재생
	void play(){
		sfSound_play( this.sound );
	}
	
	// 일시중지
	void pause(){
		sfSound_pause( this.sound );
	}
	
	// 중지
	void stop(){
		sfSound_stop( this.sound );
	}
	
	// 버퍼 설정
	void setBuffer( SoundBuffer soundBufferObject ){
		sfSound_setBuffer( this.sound, soundBufferObject.soundfBufferObject );
	}
	
	/*
	// 버퍼 얻기-보류
	SoundBuffer getBuffer(){
		return( sfSound_getBuffer() );
	}*/
	
	
	// 반복재생 설정
	void setLoop( bool loop=false ){
		sfSound_setLoop( this.sound, loop );
	}
	
	// 반복재생 값 얻기
	bool getLoop(){
		return( cast(bool)sfSound_getLoop(this.sound) );
	}
	
	/* 스테이터스 얻기 - 보류
	sfSoundStatus getStatus(){
		return( sfSound_getStatus(this.sound) );
	}*/
	
	
	// 피치 설정
	void setPitch( float pitch ){
		sfSound_setPitch( this.sound, pitch );
	}
	
	// 볼륨 설정
	void steVolume( float volume ){
		sfSound_setVolume( this.sound, volume );
	}
	
	// 포지션 설정
	void setPositoin( sfVector3f position ){
		sfSound_setPosition( this.sound, position );
	}
	
	// 관계 리스너 설정
	void setRelativeToListener( bool relative ){
		sfSound_setRelativeToListener( this.sound, relative );
	}
	
	// 최소 디스턴스 설정
	void setMinDistance( float distance ){
		sfSound_setMinDistance( this.sound, distance );
	}
	
	// Attenuation 설정
	void setAttenuation( float attenuation ){
		sfSound_setAttenuation( this.sound, attenuation );
	}
	
	// 재생 오프셋 설정
	void setPlayingOffset( sfTime timeOffset ){
		sfSound_setPlayingOffset( this.sound, timeOffset );
	}
	
	// 피치 얻기
	float getPitch(){
		return( cast(float)sfSound_getPitch(this.sound) );
	}
	
	// 볼륨 얻기
	float getVolume(){
		return( cast(float)sfSound_getVolume(this.sound) );
	}
	
	// 포지션 얻기
	sfVector3f getPosition(){
		return( sfSound_getPosition(this.sound) );
	}
	
	// 관계 리스너 설정 여부
	bool isRelativeToListener(){
		return( cast(bool)sfSound_isRelativeToListener(this.sound) );
	}
	
	// 최소 디스턴스 얻기
	float getMinDistance(){
		return( sfSound_getMinDistance(this.sound) );
	}
	
	// Auttenuation 얻기
	float getAttenuation(){
		return( sfSound_getAttenuation(this.sound) );
	}
	
	// 재생 오프셋 얻기
	sfTime getPlayingOffset(){
		return( sfSound_getPlayingOffset(this.sound) );
	}
}

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
//■
//■ sfSoundBuffer
//■
//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
class SoundBuffer{
	sfSoundBuffer* soundfBufferObject;
	
	this( string fileName ){
		this.soundfBufferObject = sfSoundBuffer_createFromFile( toStringz(fileName) );
	}
	
	void destory(){
		sfSoundBuffer_destroy( this.soundfBufferObject );

	}
	
	uint getSampleRate(){
		return( sfSoundBuffer_getSampleRate(this.soundfBufferObject) );
	}
	
	uint getChannelCount(){
		return( sfSoundBuffer_getChannelCount(this.soundfBufferObject) );
	}
	
	sfTime getDuration(){
		return( sfSoundBuffer_getDuration(this.soundfBufferObject) );
	}
}

class Vector2f{
	public float x;
	public float y;
	this(){}
	this( float x, float y){ this.x=x; this.y=y;}
}

// http 관련
enum HttpMethod{
	HttpGet, HttpPost, HttpHead
}